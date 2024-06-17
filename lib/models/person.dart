class Person{
  String name;
  String gender;
  int age;
  double weight;
  double height;
  Person({
    required this.name,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
  });
  Person.empty()
      : name = '',
        gender = '',
        age = 0,
        weight = 0,
        height = 0;
  bool isEmpty(){
    if (name == '' && gender == '' && age == 0 && weight == 0 && height == 0)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  @override
  String toString(){
      return 'Name: $name, Gender: $gender, Age: $age, Weight: $weight, Height: $height';
  }
}