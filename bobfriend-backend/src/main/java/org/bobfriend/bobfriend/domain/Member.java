package org.bobfriend.bobfriend.domain;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Document(collection = "member")
public class Member {

    @Id
    private String id;
    private String name;
    private String email;
    private String password;
    private String phoneNumber;
    private String nickName;

}
