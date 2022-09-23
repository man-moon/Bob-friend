class Regex {
  // https://stackoverflow.com/a/32686261/9449426
  static final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
}

String? emailValidator(value) {
  if (value!.isEmpty || !Regex.email.hasMatch(value)) {
    return '이메일 형식을 확인해주세요';
  }
  return null;
}

String? passwordValidator(value) {
  if (value!.isEmpty || value.length < 6) {
    return '비밀번호는 6자 이상입니다';
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
