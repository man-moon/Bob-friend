package org.bobfriend.bobfriend.repository;

import org.bobfriend.bobfriend.domain.Member;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface MemberRepository extends MongoRepository<Member, String> {

}
