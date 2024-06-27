import 'dart:math';
import 'package:healthy_eating_diary/main.dart';

class Message {
  
  double normCalories;
  double consumedCalories;
  List<String> supportMessages1 = ['Молодец!',  'Так держать!',   'Замечательно!',  'Вау!',  'Ух ты!',  'Круто!' ,  'Здорово!'  ,'Прекрасно!' ,  'Восхитительно!',  'Вдохновляюще!',  'Поразительно!',  'Великолепно!',  'Впечатляюще!',  'Безупречно!'  ,'Превосходно!'  ,'Умопомрачительно!'  ,'Отлично!'];
  
  String praiseMessages1 ='К сожалению,';

  List<String> raiseMessages2 = ['цель не достигнута.',   'задача не выполнена.',  'не получен желаемый результат.',  'план не выполнен.',  'потреблено кбжу не в соответствии с нормой.',  'выбор блюд и их количества неверен.',  'прием пищи не принес максимальное количество пользы.'];

  List<String> supportMessages2 = ['Норма выполнена.',  'Цель достигнута.',  'Желаемые кбжу потреблены.',   'Задача  выполнена.',  'Получен желаемый результат.',  'План выполнен.',  'Потреблено кбжу в соответствии с нормой.',  'Выбор блюд верен.',  'Прием пищи принес максимальное количество пользы.'];

  List<String> lastMessages = ['Продолжай питаться правильно',   'Действуй в выбранном направлении',  'Не останавливайся',  'Продолжай уделять внимание своему питанию',  'Продолжай осознанно питаться',  'Следуй по выбранному пути',  'Держи курс на успех','Только вперед',  'Будь настойчив',  'Продолжай движение вперед'];

  
  Message(MainAppState mainAppState)
    : normCalories = mainAppState.kcalNormal,
      consumedCalories = mainAppState.consumedSubstances[0];

  // Метод, который проверяет, выполнена ли норма потребления калорий
  bool isNormMet() {
    return 0.9 * normCalories <= consumedCalories && consumedCalories <= 1.1 * normCalories;
  }

  // Метод, который выбирает случайную строку из переданного массива
  String chooseMessage(List<String> messages) {
    final random = Random();
    int index = random.nextInt(messages.length);
    return messages[index];
  }

  // Метод, который создаёт строку в зависимости от выполнения нормы
  String createMessage() {
    if (isNormMet()) {
      return '${chooseMessage(supportMessages1)}' ' ${chooseMessage(supportMessages2)}' ' ${chooseMessage(lastMessages)}!';
    } else {
      return '$praiseMessages1' ' ${chooseMessage(raiseMessages2)}' ' ${chooseMessage(lastMessages)}!';
    }
  }

  String photo() {
    if (isNormMet()){
      return 'assets/images/happy.png';
    } else {
      return 'assets/images/editing.png';
    }
  }
}