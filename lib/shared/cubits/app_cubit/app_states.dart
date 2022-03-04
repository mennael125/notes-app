abstract class NotesAppStates {}
class DarkStateChange extends NotesAppStates {}

class NotesAppInitialState extends NotesAppStates {}

class LogOutSuccessState extends NotesAppStates{
  // final uID;
  //
  // LogOutSuccessState(this.uID);
}
class LogOutLoadingState extends NotesAppStates{

}
class LogOutErrorState extends NotesAppStates{}
class EmptySuccess extends NotesAppStates{}
//test fire store

class FirestoreStateTest extends NotesAppStates{}
class FirestoreStateLoadingTest
    extends NotesAppStates{}
class FirestoreErrorTest
    extends NotesAppStates{}
class ConfirmSuccess extends NotesAppStates {}

