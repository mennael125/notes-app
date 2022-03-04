class AddNoteModel{
  String ? title ;
  String ? note ;
  String? uID;

  var image ;
  AddNoteModel ({
    this.note,
    this.title,
    this.image,
    this.uID,
  }

      );
  AddNoteModel.fromJson(Map<String, dynamic> json){

    note=json['note'] ;
    title=json['title'] ;
    image=json['image'] ;
    uID = json['uID'];


  }


}