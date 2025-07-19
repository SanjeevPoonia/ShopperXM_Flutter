
class AppModel{


  static bool isLogin=false;
  static String token='';
  static String userID='';
  static String userType='';


  static bool setLoginToken(bool value)
  {
    isLogin=value;
    return isLogin;
  }
  static String setTokenValue(String value)
  {
    token=value;
    return token;
  }
  static String setUserID(String value)
  {
    userID=value;
    return userID;
  }
  static String setUserType(String value)
  {
    userType=value;
    return userType;
  }




}
