//
//  ActivityIndicator.swift
//  RxSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/07/21.
//  Copyright © 2016年 Hiroki Yoshifuji. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa


private struct ActivityToken<E> : ObservableConvertibleType, Disposable {
    
    private let _source: Observable<E>
    private let _dispose: AnonymousDisposable
    
    init(source: Observable<E>, disposeAction: () -> ()) {
        _source = source
        _dispose = AnonymousDisposable(disposeAction)
    }
    
    func dispose() {
        _dispose.dispose()
    }
    
    func asObservable() -> Observable<E> {
        return _source
    }
}


public class ActivityIndicator : DriverConvertibleType {
    public typealias E = Bool
    
    private let _lock = NSRecursiveLock()
    private let _variable = Variable(0)
    private let _loading: Driver<Bool>
    
    public init() {
        _loading = _variable.asObservable()
            .map { $0 > 0 }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: ActivityIndicator.ifItStillErrors)
    }
    
    private static func ifItStillErrors(error: ErrorType) -> Driver<Bool> {
        _ = fatalError("Loader can't fail")
        
    }
    
    private func trackActivityOfObservable<O: ObservableConvertibleType>(source: O) -> Observable<O.E> {
        
        return Observable.using({ () -> ActivityToken<O.E> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { t in
            return t.asObservable()
        }
    }
    
    private func increment() {
        _lock.lock()
        _variable.value = _variable.value + 1
        _lock.unlock()
    }
    
    private func decrement() {
        _lock.lock()
        _variable.value = _variable.value - 1
        _lock.unlock()
    }
    
    public func asDriver() -> Driver<E> {
        return _loading
    }
    
}

public extension ObservableConvertibleType {
    public func trackActivity(activityIndicator: ActivityIndicator) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}