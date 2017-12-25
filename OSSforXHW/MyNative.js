//notation: js file can only use this kind of comments
//since comments will cause error when use in webview.loadurl,
//comments will be remove by java use regexp
;(function() {
  if (window.MyNative) {
  return;
  }
  
  var messagingIframe;
  var sendMessageQueue = [];
  var receiveMessageQueue = [];
  var messageHandlers = {};
  
  var CUSTOM_PROTOCOL_SCHEME = 'wvjbscheme';
  var QUEUE_HAS_MESSAGE = '__WVJB_QUEUE_MESSAGE__';
  
  var responseCallbacks = {};
  var uniqueId = 1;
  
  function _createQueueReadyIframe(doc) {
  messagingIframe = doc.createElement('iframe');
  messagingIframe.style.display = 'none';
  doc.documentElement.appendChild(messagingIframe);
  }
  
  
  
  
  
  //set default messageHandler
  function init(messageHandler)
  {
  if (MyNative._messageHandler) {
  throw new Error('MyNative.init called twice');
  }
  MyNative._messageHandler = messageHandler;
  var receivedMessages = receiveMessageQueue;
  receiveMessageQueue = null;
  for (var i = 0; i < receivedMessages.length; i++) {
  _dispatchMessageFromObjC(receivedMessages[i]);
  }
  }
  
  function send(data, responseCallback) {
  _doSend({
          data: data
          }, responseCallback)
  }
  
  
  function connectWebViewJavascriptBridge(callback) {
  if (window.MyNative) {
  callback(MyNative)
  } else {
  document.addEventListener('MyNativeReady', function() {
                            callback(MyNative)
                            }, false)
  }
  }
  
  
  connectWebViewJavascriptBridge(function(MyNative) {
                                 
                                 MyNative.init(function(message, responseCallback) {
                                               
                                               })
                                 
                                 })
  
  
  
  function registerHandler(handlerName, handler) {
  messageHandlers[handlerName] = handler;
  }
  
  function api(handlerName, data, responseCallback) {
  _doSend({
          handlerName: handlerName,
          data: data
          }, responseCallback)
  }
  function countSorting(data){
  
  }
  function windows(handlerName, data, responseCallback) {
  _doSend({
          handlerName: handlerName,
          data: data
          }, responseCallback)
  }
  function camera(handlerName, data, responseCallback) {
		_doSend({ handlerName:handlerName, data:data }, responseCallback)
  }
  function business(handlerName, data, responseCallback) {
  _doSend({
          handlerName: handlerName,
          data: data
          }, responseCallback)
  }
  function oauth(handlerName, data, responseCallback) {
  _doSend({
          handlerName: handlerName,
          data: data
          }, responseCallback)
  }
  function geolocation(handlerName, data, responseCallback) {
  _doSend({
          handlerName: handlerName,
          data: data
          }, responseCallback)
  }
  function callHandler(handlerName, data, responseCallback) {
		_doSend({ handlerName:handlerName, data:data }, responseCallback)
  }
  //sendMessage add message, 触发native处理 sendMessage
  function _doSend(message, responseCallback)
  {
  if (responseCallback)
  {
  var callbackId = 'cb_' + (uniqueId++) + '_' + new Date().getTime();
  responseCallbacks[callbackId] = responseCallback;
  message.callbackId = callbackId;
  }
  
  sendMessageQueue.push(message);
  messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + QUEUE_HAS_MESSAGE;
  }
  
  
  function _fetchQueue() {
  var messageQueueString = JSON.stringify(sendMessageQueue)
  sendMessageQueue = []
  //  messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + encodeURIComponent(messageQueueString);
  return messageQueueString
  }
  
  function _dispatchMessageFromObjC(messageJSON) {
		setTimeout(function _timeoutDispatchMessageFromObjC() {
                   var message = JSON.parse(messageJSON)
                   var messageHandler
                   var responseCallback
                   
                   if (message.responseId) {
                   responseCallback = responseCallbacks[message.responseId]
                   if (!responseCallback) { return; }
                   responseCallback(message.responseData)
                   delete responseCallbacks[message.responseId]
                   } else {
                   if (message.callbackId) {
                   var callbackResponseId = message.callbackId
                   responseCallback = function(responseData) {
                   _doSend({ responseId:callbackResponseId, responseData:responseData })
                   }
                   }
                   
                   var handler = MyNative._messageHandler
                   if (message.handlerName) {
                   handler = messageHandlers[message.handlerName]
                   }
                   
                   try {
                   handler(message.data, responseCallback)
                   } catch(exception) {
                   if (typeof console != 'undefined') {
                   console.log("WebViewJavascriptBridge: WARNING: javascript handler threw.", message, exception)
                   }
                   }
                   }
                   })
  }
  
  function _handleMessageFromObjC(messageJSON) {
		if (receiveMessageQueue) {
  receiveMessageQueue.push(messageJSON)
		} else {
  _dispatchMessageFromObjC(messageJSON)
		}
  }
  
  
  //   var MyNative =
  window.MyNative =
  {
  init: init,
  send: send,
  registerHandler: registerHandler,
  api: api,
  windows:windows,
  camera:camera,
  business:business,
  oauth:oauth,
  geolocation:geolocation,
  callHandler: callHandler,
  _fetchQueue: _fetchQueue,
  countSorting:countSorting,
  _handleMessageFromObjC: _handleMessageFromObjC
  
  };
  
  function setupWebViewJavascriptBridge(callback) {
  if (window.MyNative) { return callback(MyNative); }
  if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
  window.WVJBCallbacks = [callback];
  var WVJBIframe = document.createElement('iframe');
  WVJBIframe.style.display = 'none';
  WVJBIframe.src = 'https://__bridge_loaded__';
  document.documentElement.appendChild(WVJBIframe);
  setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
  }
  
  var doc = document;
  _createQueueReadyIframe(doc);
  var readyEvent = doc.createEvent('Events');
  readyEvent.initEvent('MyNativeReady');
  readyEvent.bridge = MyNative;
  doc.dispatchEvent(readyEvent);
  })();

//function callbackFunction_parse(val) {
//    //                alert("zm");
//    try{
//        eval("var temp="+val);
//        //                    alert(temp.method);
//        var val =temp.param;
//        //                    alert(val[0].name);
//        eval(temp.method+"(val);");
//    }catch (e){
//        alert("回调执行出错了:"+e);
//    }
//}
