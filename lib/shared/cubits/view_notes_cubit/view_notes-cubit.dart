import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/shared/cubits/view_notes_cubit/view_notes_states.dart';

class ViewNotesCubit extends Cubit<InitialViewState>{
  ViewNotesCubit() : super(InitialViewState());
  static ViewNotesCubit get(context)=>BlocProvider.of(context);
}