import 'dart:math';
import 'package:healthy_eating_diary/main.dart';

class Message {
  
  double normCalories;
  double consumedCalories;
  List<String> supportMessages = ['Молодец!',  'Так держать!',   'Замечательно!',  'Вау!',  'Ух ты!',  'Круто!' ,  'Здорово!'  ,'Прекрасно!' ,  'Восхитительно!',  'Вдохновляюще!',  'Поразительно!',  'Великолепно!',  'Впечатляюще!',  'Безупречно!'  ,'Превосходно!'  ,'Умопомрачительно!'  ,'Отлично!'];
  
  String praiseMessages ='К сожалению,';

  List<String> result1 = ['цель по калориям не достигнута.',   'задача по калориям не выполнена.',  'не получен желаемый результат калорий.',  'план по калориям не выполнен.',  'потреблено калорий меньше нормы.',  'потребленных калорий недостаточно.'];

  List<String> result2 = ['Норма калорий выполнена.',  'Цель для калорий достигнута.',  'Желаемые калории потреблены.',   'Задача по калориям выполнена.',  'Получен желаемый результат калорий.',  'План по калориям выполнен.',  'Потреблено калорий в соответствии с нормой.',  'Выбор калорийности блюд верен.'];

  List<String> result3 = ['потреблено калорий больше нормы.', 'выбор калорийности блюд черезмерен.',  'потреблено больше калорий, чем следует'];
  List<String> lastMessages1 = ['Удели больше внимания выбору блюд.', 'Продолжай уделять внимание своему питанию!', 'Продолжай движение вперед!', 'Не расстраивайся, всё получится!'];
  List<String> lastMessages2 = ['Продолжай питаться правильно.',   'Действуй в выбранном направлении.',  'Продолжай уделять внимание своему питанию.',  'Продолжай осознанно питаться.',  'Следуй по выбранному пути.','Только вперед!', 'Продолжай движение вперед!'];
  List<String> lastMessages3 = ['Удели больше внимания выбору блюд.',  'Постарайся питаться осознанно.', 'Подумай, что является причиной.', 'Попробуй сократить объем порций.', 'У тебя обязательно получится!', 'Не кори себя, ты справишься!', 'Для укрепления привычки нужно время.', 'Ничего страшного, ты справишься!'];
  
  Message(MainAppState mainAppState)
    : normCalories = mainAppState.kcalNormal,
      consumedCalories = mainAppState.consumedSubstances[0];

  // Метод, который проверяет, выполнена ли норма потребления калорий
  int isNormMet() {
    if (consumedCalories < normCalories ) {
      return 1;
    }
    if (consumedCalories <= normCalories){
      return 2;
    }
    return 3;
  }

  // Метод, который выбирает случайную строку из переданного массива
  String chooseMessage(List<String> messages) {
    final random = Random();
    int index = random.nextInt(messages.length);
    return messages[index];
  }

  // Метод, который создаёт строку в зависимости от выполнения нормы
  String createMessage() {
    if (isNormMet() == 1) {
      return '$praiseMessages' ' ${chooseMessage(result1)}' ' ${chooseMessage(lastMessages1)}';
    }
    if (isNormMet() == 2){
      return ' ${chooseMessage(supportMessages)}' ' ${chooseMessage(result2)}' ' ${chooseMessage(lastMessages2)}';
    }
    return '$praiseMessages' ' ${chooseMessage(result3)}' ' ${chooseMessage(lastMessages3)}';
    
  }

  String photo() {
    if (isNormMet() == 2){
      return 'assets/images/happy.png';
    } else {
      return 'assets/images/slightly_dissapointed.png';
    }
  }
}