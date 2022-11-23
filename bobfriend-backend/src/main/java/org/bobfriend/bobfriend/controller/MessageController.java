package org.bobfriend.bobfriend.controller;

import org.bobfriend.bobfriend.domain.Message;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class MessageController {

    @MessageMapping("/message")
    @SendTo("/topic/message")
    public Message greeting(Message message) throws Exception {
        //Thread.sleep(1000);
        return new Message(message.getContent());
    }
}
