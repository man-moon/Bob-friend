package org.bobfriend.bobfriend.dto;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public class MessageDto {
    String to;
    String content;
}
