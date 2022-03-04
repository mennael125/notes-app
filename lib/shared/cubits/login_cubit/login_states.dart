abstract class LoginStates {}
class LoginInitialState extends LoginStates{}

class LoginPasswordShowState extends LoginStates{}
class LoginSuccessState extends LoginStates{
  final uID;

  LoginSuccessState(this.uID);
}
class LoginLoadingState extends LoginStates{

}
class LoginErrorState extends LoginStates{}
class ShowToastState extends LoginStates{}

