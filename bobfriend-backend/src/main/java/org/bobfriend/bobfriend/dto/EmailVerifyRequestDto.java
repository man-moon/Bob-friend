package org.bobfriend.bobfriend.dto;

import lombok.Data;

import javax.validation.constraints.NotEmpty;

@Data
public class EmailVerifyRequestDto {

    @NotEmpty(message = "이메일을 입력해주세요")
    public String email;
}
