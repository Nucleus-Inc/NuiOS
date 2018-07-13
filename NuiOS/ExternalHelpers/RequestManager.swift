//
//  UrlRequestHelper.swift
//  MeaStartIntegration
//
//  Created by Nucleus on 07/06/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import Foundation
public typealias RequestError = Error

public typealias OnFailureHandler<D:Decodable,J> = (Response<D,J>.Data,HTTPURLResponse?,RequestError?)->Void
public typealias OnSuccessHandler<D:Decodable,J> = (Response<D,J>.Data,HTTPURLResponse?)->Void


public struct EndpointInfo{
    var url:String
    var method:HTTPMethod
    var params:[String:Any]?
    var headers:[String:String]?
    var cache:URLRequest.CachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy
    var timeout:TimeInterval = 60.0
    
    fileprivate var httpBody:Data?
    
    init(url:String,method:HTTPMethod,params:[String:Any]?=nil,options:JSONSerialization.WritingOptions = .prettyPrinted,headers:[String:String]?=nil) throws {
        self.url = url
        self.method = method
        self.params = params
        self.headers = headers
    
        if let params = params{
            httpBody = try JSONSerialization.data(withJSONObject: params, options: options)
        }
    }
    
    init<T:Encodable>(url:String,method:HTTPMethod,object:T?,headers:[String:String]?=nil) throws {
        self.url = url
        self.method = method
        self.headers = headers
        
        if let object = object{
            httpBody = try JSONEncoder().encode(object)
        }
    }
    
}

public protocol ChildEndpoint:Endpoint{
    associatedtype Father:Endpoint
}

public protocol Endpoint{
    static var title:String{get}
    func endpointInfo() throws -> EndpointInfo
    //static func fromBaseEndpoint<T:Endpoint>(BaseEndpoint endpoint:T) throws ->EndpointInfo
}

public extension Endpoint{
    func endpointInfo<T:ChildEndpoint>(ForChild child:T) throws ->EndpointInfo{
        var info = try self.endpointInfo()
        let childTitle = T.title
        let title = T.Father.title
        info.url = info.url.replacingOccurrences(of: title, with: childTitle)
        return info
    }
}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public struct Response<T:Decodable,O>{
    
    public struct OnFailure{
        public var responseHandler: OnFailureHandler<T,O>
        public init(dataType:T.Type,jsonType:O.Type,responseHandler: @escaping OnFailureHandler<T,O>) {
            self.responseHandler = responseHandler
        }
    }

    public struct OnSuccess{
        public var responseHandler: OnSuccessHandler<T,O>
        public init(dataType:T.Type,jsonType:O.Type,responseHandler: @escaping OnSuccessHandler<T,O>) {
            self.responseHandler = responseHandler
        }
    }

    public struct Data{
        public var data:T?
        public var json:O?
        public var serializationError:Error?
    }
    
}

public class RequestManager{
    
    public static let backgroundSession = URLSession(configuration: .background(withIdentifier: "UrlRequestHelper.backgroundSession"), delegate: nil, delegateQueue: OperationQueue.current)
    
    public enum Errors:Error{
        case incompatibleUrlFormat(description:String)
    }
    
    /**
     Uses URLSession.shared
     */
    @discardableResult
    public class func send<D:Decodable,J:Any,E:Decodable,R:Any>(To endpoint:Endpoint,onSuccess:Response<D, J>.OnSuccess,onFailure:Response<E, R>.OnFailure) throws ->URLSessionTask  {
        return try sendOnSession(session: URLSession.shared, To: endpoint.endpointInfo(), onSuccess: onSuccess, onFailure: onFailure)
    }

    /**
     Uses UrlRequestHelper.backgroundSession
     */
    @discardableResult
    public class func sendRequestOnBackgroundSession<D:Decodable,J:Any,E:Decodable,R:Any>(To endpoint:Endpoint,onSuccess:Response<D, J>.OnSuccess,onFailure:Response<E, R>.OnFailure) throws ->URLSessionTask  {
        return try sendOnSession(session: RequestManager.backgroundSession, To: endpoint.endpointInfo(), onSuccess: onSuccess, onFailure: onFailure)
    }

    @discardableResult
    public class func sendOnSession<D:Decodable,J:Any,E:Decodable,R:Any>(session:URLSession,To endpoint:Endpoint,onSuccess:Response<D, J>.OnSuccess,onFailure:Response<E, R>.OnFailure) throws ->URLSessionTask  {
        return try sendOnSession(session: session, To: endpoint.endpointInfo(), onSuccess: onSuccess, onFailure: onFailure)
    }
    
    @discardableResult
    public class func sendOnSession<D:Decodable,J:Any,E:Decodable,R:Any>(session:URLSession,To endpoint:EndpointInfo,onSuccess:Response<D, J>.OnSuccess,onFailure:Response<E, R>.OnFailure) throws ->URLSessionTask  {
        return try sendOnSession(session: session, ToUrl: endpoint.url, httpMethod: endpoint.method, httpBody: endpoint.httpBody, headers: endpoint.headers, cache: endpoint.cache, timeout: endpoint.timeout, onSuccess: onSuccess, onFailure: onFailure)
    }

    
    
    @discardableResult
    private class func sendOnSession<D:Decodable,J:Any,E:Decodable,R:Any>(session:URLSession,ToUrl urlString:String,httpMethod:HTTPMethod,httpBody:Data?,headers:[String:String]?=nil,cache:URLRequest.CachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy, timeout:TimeInterval = 60.0,onSuccess:Response<D, J>.OnSuccess,onFailure:Response<E, R>.OnFailure) throws ->URLSessionTask  {
        
        if let formattedString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),let url = URL(string: formattedString){
            var urlReq = URLRequest(url: url, cachePolicy: cache, timeoutInterval: timeout)
            
            urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
            for key in headers?.arrayOfKeys() ?? []{
                if let value = headers?[key]{
                    urlReq.addValue(value, forHTTPHeaderField: key)
                }
            }
            urlReq.httpMethod = httpMethod.rawValue
            urlReq.httpBody = httpBody

            let sessionTask = session.dataTask(with: urlReq) { (data, urlResp, error) in

                func generateData<K:Decodable,L:Any>(DataType dataType:K.Type, jsonType:L.Type,FromData data:Data?)->Response<K,L>.Data{
                    var responseData:Response.Data = Response<K,L>.Data(data: nil, json: nil,serializationError: nil)
                    if let data = data, data.count > 0 {
                        do{
                            responseData.json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? L
                            responseData.data = try JSONDecoder().decode(K.self, from: data)
                        }
                        catch{
                            responseData.serializationError = error
                        }
                    }
                    return responseData
                }

                guard let e = error else{
                    if let httpResp = urlResp as? HTTPURLResponse{
                        let success = httpResp.statusCode  < 300
                        if success{
                            let responseData = generateData(DataType: D.self, jsonType: J.self, FromData: data)
                            onSuccess.responseHandler(responseData,httpResp)
                        }
                        else{
                            let responseData = generateData(DataType: E.self, jsonType: R.self, FromData: data)
                            onFailure.responseHandler(responseData,httpResp,nil)
                        }
                    }
                    return
                }
                
                let responseData = generateData(DataType: E.self, jsonType: R.self, FromData: data)
                onFailure.responseHandler(responseData,urlResp as? HTTPURLResponse,e)
                
            }
            
            sessionTask.resume()
            return sessionTask
        }
        else{
            throw Errors.incompatibleUrlFormat(description: "Could not generate 'URL' instance from "+urlString)
        }
        
    }

}

fileprivate extension Dictionary{
    func arrayOfKeys()-> [Key]{
        return [Key](self.keys)
    }
}

extension Encodable{
    func toJSON()->[String:Any]?{
        do{
            let data = try JSONEncoder().encode(self)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
            return json
        }
        catch{
            print(error.localizedDescription)
            return nil
        }
    }
}
