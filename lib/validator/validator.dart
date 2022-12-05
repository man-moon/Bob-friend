import 'package:flutter/material.dart';

class Regex {
  // https://stackoverflow.com/a/32686261/9449426
  static final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
}

String? emailValidator(value) {
  if(value!.isEmpty){
    return '';
  }
  if (!Regex.email.hasMatch(value)) {
    return '이메일 형식을 확인해주세요';
  }

  String emailDomain = value.split('@')[1];
  if(emailDomain != 'ajou.ac.kr' && emailDomain != 'inha.edu.kr') {
    return '학교 이메일만 허용됩니다';
  }
  return null;
}

String? ownerEmailValidator(value) {
  if(value!.isEmpty){
    return '';
  }
  if (!Regex.email.hasMatch(value)) {
    return '이메일 형식을 확인해주세요';
  }
  return null;
}

String? emailVerificationCodeValidator(value) {
  if(value!.length < 4){
    return '';
  }
  return null;
}

String? passwordValidator(value) {
  if (value!.isEmpty || value.length < 6) {
    return '비밀번호는 6자 이상으로 해주세요';
  }
  return null;
}

String? passwordCheckValidator(password, checkPassword) {
  if(checkPassword.isEmpty){
    return '';
  }
  if (password != checkPassword) {
    return '비밀번호가 일치하지 않아요';
  }
  return null;
}

String? nicknameValidator(value) {
  if(value!.isEmpty) {
    return '닉네임을 입력해주세요';
  }
  if(value!.length < 2) {
    return '닉네임은 2글자 이상입니다';
  }
  if(value!.length > 12) {
    return '닉네임은 12글자 이하입니다';
  }
  return null;
}

String? restaurantNameValidator(value) {
  if(value!.isEmpty) {
    return '상호명을 입력해주세요';
  }
  return null;
}

String? restaurantAddressValidator(value) {
  if(value!.isEmpty) {
    return '주소를 입력해주세요';
  }
  return null;
}

String? restaurantDetailAddressValidator(value) {
  if(value!.isEmpty) {
    return '상세주소를 입력해주세요';
  }
  return null;
}

String? phoneNumberValidator(value) {
  if(value!.length == 11) {
    return null;
  } else {
    return '';
  }
}

String? phoneNumberCertificationCodeValidator(value) {
  if(value!.length == 6) {
    return null;
  } else {
    return '';
  }
}