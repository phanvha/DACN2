
class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({this.image, this.title, this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
    title: 'Select Location',
    image: 'assets/images/search_location.json',
    discription: "Allow the user to quickly search for the desired location."
  ),
  UnbordingContent(
    title: 'Alert bad road',
    image: 'assets/images/alert.json',
    discription: "Warning spots with bad roads on the way you go."
  ),
  UnbordingContent(
    title: 'Easy navigation',
    image: 'assets/images/navigation.json',
    discription: "Navigation your way to the desired location on the map with easy."
  ),
];
