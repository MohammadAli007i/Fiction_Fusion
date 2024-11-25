class UnboardingContent{
  String image;
  String title;
  String description;
  UnboardingContent(
      {required this.description , required this.image , required this.title}
      );
}
List<UnboardingContent> contents = [
  UnboardingContent(description: 'Discover Your Next Favorite Book.', image: "assets/logo.webp", title: "Welcome to [FictionFusion]!"),
  UnboardingContent(description: 'Keep track of the books you love!',image: "assets/logo.webp", title: "Organize Your Reading List"),
  UnboardingContent(description: 'Connect with other book lovers!', image: "assets/logo.webp", title: "Join the Reading Community"),
  UnboardingContent(description: 'Ready to embark on your reading   \n adventure?', image: "assets/logo.webp", title: "Get Started"),
];