//
//  MessagesViewController.swift
//  iMessagesClone
//
//  Created by 小菅仁士 on 2016/04/11.
//  Copyright © 2016年 Ryo. All rights reserved.
//


import UIKit
import Parse
import Photos

class MessagesViewController: JSQMessagesViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var conversation: Conversation!
    var incomingUser: User!
    
    private let currentUser = PFUser.currentUser()!
    private var users = [User]()
    
    private var jsqMessages = [JSQMessage]()
    private var messages = [Message]()
    
    private var outgoingBubbleImage: JSQMessagesBubbleImage!
    private var incomingBubbleImage: JSQMessagesBubbleImage!
    
    private var selfAvator: JSQMessagesAvatarImage!
    private var incomingAvator: JSQMessagesAvatarImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inputToolbar?.contentView?.leftBarButtonItem?.setImage(UIImage(named: "Camera-1"), forState: .Normal)
        self.inputToolbar?.contentView?.leftBarButtonItem?.setImage(UIImage(named: "Camera-1"), forState: .Highlighted)
        
        self.inputToolbar?.contentView?.leftBarButtonItem?.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        title = incomingUser.username!
        
        self.collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(16.0, 16.0)
        
        self.senderId = currentUser.objectId!
        self.senderDisplayName = currentUser.username!
        
        setupAvatorImages()
        createMessagesBubbles()
        loadMessages()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.keyboardController.textView?.becomeFirstResponder()
    }
    
    
    
    //両方のユーザーのイメージをセット
    private func setupAvatorImages() {
        incomingUser.profileImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            if error == nil && data != nil {
                self.incomingAvator = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: data!)!, diameter:UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
            }
        }
        
        (currentUser as! User).profileImageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            self.selfAvator = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: data!)!, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        }
    }
    
    
    //メッセージの背景となる吹き出し
    private func createMessagesBubbles() {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor(red: 12 / 255.0, green: 1330.0 / 255.0, blue: 254.0 / 255.0, alpha: 1))
        incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor(red: 229.0 / 255.0, green: 229.0 / 255.0, blue: 234.0 / 255.0, alpha: 1))
    }
    
    
    //メッセージを読み込む
    //パースからメッセージデータを持ってくる。
    
    private func loadMessages() {
        var lastMessage: JSQMessage? = nil
        
        if jsqMessages.last != nil {
            lastMessage = jsqMessages.last
        }
        
        let messageQuery = PFQuery(className: Message.parseClassName())
        messageQuery.whereKey("conversationId", equalTo: (conversation?.objectId!)!)
        messageQuery.orderByAscending("createdAt")
        messageQuery.limit = 100
        messageQuery.cachePolicy = .NetworkElseCache
        messageQuery.includeKey("sender")
        
        if lastMessage != nil {
            messageQuery.whereKey("createdAt", greaterThan: (lastMessage?.date)!)
        }
        
        messageQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                if let object = objects as [PFObject]! {
                    
                    for object in objects! {
                        let message = object as! Message
                        self.messages.append(message)
                        
                        let sender = message.sender as! User
                        self.users.append(sender)
                        
                        if message.photoFile == nil {
                            let jsqMessage = JSQMessage(senderId: sender.objectId!, senderDisplayName: sender.username!, date: message.createdAt!, text: message.text)
                            self.jsqMessages.append(jsqMessage)
                            
                            if objects?.count != 0 {
                                self.finishReceivingMessage()
                            }
                            
                        } else {
                            
                            let photoMediaItem = JSQPhotoMediaItem(image: nil)
                            var newMessage = JSQMessage(senderId: sender.objectId!, displayName: self.senderDisplayName, media: photoMediaItem)
                            self.jsqMessages.append(newMessage)
                            
                            message.photoFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                                
                                if error == nil && data != nil {
                                    photoMediaItem.image = UIImage(data: data!)!
                                    newMessage = JSQMessage(senderId: sender.objectId!, displayName: self.senderDisplayName, media: photoMediaItem)
                                    
                                    if objects?.count != 0 {
                                        self.finishReceivingMessage()
                                    }
                                }
                            })
                        }
                    }
                }
                
                
                
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    //sendボタンが押された時の処理
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = Message(text: text, sender: PFUser.currentUser()!, conversationId: conversation.objectId!)
        message.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.conversation.lastUpdate = NSDate()
                self.conversation.saveInBackground()
                self.loadMessages()
                
                
            }
            
            self.finishSendingMessage()
        }
    }
    
    
    //カメラボタンが押された時の処理
    override func didPressAccessoryButton(sender: UIButton!) {
        let authorication = PHPhotoLibrary.authorizationStatus()
        
        if authorication == .NotDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.didPressAccessoryButton(sender)
                })
            })
            return
        }
        
        if authorication == .Authorized {
            let controller = ImagePickerSheetController()
            controller.addAction(ImageAction(title: NSLocalizedString("take Photo or video", comment: "ActionTitle"), secondaryTitle: NSLocalizedString("Send Photo", comment: "ActionTitle"), handler: { (_) -> () in
                self.presentCamera()
                
                
                }, secondaryHandler: { (action, numberOfPhotos) -> () in
                    controller.getSelectedImagesWithCompletion({ (images) -> Void in
                        self.sendPhoto(images[0]!)
                        
                    })
            }))
            
            controller.addAction(ImageAction(title: NSLocalizedString("Cancel", comment: "ActionTitle"), style: .Cancel, handler: nil, secondaryHandler: nil))
            presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    //MARK: - 写真を送る。
    private func sendPhoto(photo: UIImage) {
        let message = Message(photo: photo, sender: PFUser.currentUser()!, conversationId: conversation.objectId!)
        message.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.conversation.lastUpdate = NSDate()
                self.conversation.saveInBackground()
                self.loadMessages()
            }
            
            self.finishSendingMessage()
        }
    }
    
    
    //MARK: - カメラを起動する。
    private func presentCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    //コレクションビューの数を決める。
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return jsqMessages[indexPath.row]
    }
    
    
    //吹き出しの設定
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = jsqMessages[indexPath.row]
        
        if message.senderId == self.senderId {
            return outgoingBubbleImage
        } else {
            return incomingBubbleImage
        }
    }
    
    
    //ユーザーのプロフィール写真を表示するImageView
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = jsqMessages[indexPath.row]
        
        if message.senderId == self.senderId {
            return selfAvator
        } else {
            return incomingAvator
        }
    }
    
    
    //日付を表示する
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        if indexPath.item % 10 == 0 {
            let message = jsqMessages[indexPath.row]
            
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        
        return nil
    }
    
    
    //日付を表示するためのスペース
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item % 10 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0
    }
    
    
    //送信された画像をクリックした時の処理
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        let jsqMessage = jsqMessages[indexPath.row]
        
        if jsqMessage.media != nil {
            if let imageView = jsqMessage.media.mediaView() as? UIImageView {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let photoViewController = storyboard.instantiateViewControllerWithIdentifier("PhotoViewController") as! PhotoViewController
                photoViewController.image = imageView.image
                photoViewController.senderName = jsqMessage.senderDisplayName
                self.navigationController?.pushViewController(photoViewController, animated: true)
            }
        }
    }
    
    
    
    //メッセージを表示する
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsqMessages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = jsqMessages[indexPath.row]
        
        if message.media == nil {
            if message.senderId == self.senderId {
                cell.textView?.textColor = UIColor.whiteColor()
            } else {
                cell.textView?.textColor = UIColor.blackColor()
            }
            
            cell.textView?.linkTextAttributes = [NSForegroundColorAttributeName: (cell.textView?.textColor)!]
        }
        return cell
    }
}
