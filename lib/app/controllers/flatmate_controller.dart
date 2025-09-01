import 'package:get/get.dart';

class FlatmateController extends GetxController {
  // Current index of the top card
  final currentIndex = 0.obs;

  // Get the current card data
  Map<String, dynamic> get currentCard =>
      recommendedFlatmates[currentIndex.value];

  // Check if there are more cards
  bool get hasMoreCards => currentIndex.value < recommendedFlatmates.length - 1;

  // Get the tilt angle based on card position
  double getCardTilt(int index) {
    // Convert degrees to radians for Flutter's rotation
    return index % 2 == 0 ? 0.1316 : -0.105; // -6.02° and 7.54° in radians
  }

  // Navigate to next card
  void nextCard() {
    if (hasMoreCards) {
      currentIndex.value++;
    }
  }

  // Navigate to previous card
  void previousCard() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  // Mock data for recommended flatmates
  final recommendedFlatmates = <Map<String, dynamic>>[
    {
      'name': 'Amed Sam',
      'age': 30,
      'occupation': 'Doctor',
      'matchPercentage': 95,
      'image': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
      'location': 'Abuja',
      'religion': 'Christian',
      'income': '₦400k - ₦600k/yr',
      'interests': ['Reading', 'Fitness', 'Travel'],
      'bio':
          'Medical professional looking for a clean and organized living space. I work long hours but enjoy socializing on weekends.',
      'moveInDate': 'September 1',
      'preferredRent': '₦250k - ₦350k',
      'smokingPreference': 'Non-smoker',
      'petPreference': 'No pets',
    },
    {
      'name': 'Jessica Okoli',
      'age': 28,
      'occupation': 'Financial Analyst',
      'matchPercentage': 92,
      'image': 'https://images.unsplash.com/photo-1531123897727-8f129e1688ce',
      'location': 'Lagos',
      'religion': 'Christian',
      'income': '₦350k - ₦500k/yr',
      'interests': ['Cooking', 'Yoga', 'Movies'],
      'bio':
          'Finance professional who enjoys a balanced lifestyle. Looking for a roommate who appreciates cleanliness and occasional shared meals.',
      'moveInDate': 'August 15',
      'preferredRent': '₦200k - ₦300k',
      'smokingPreference': 'Non-smoker',
      'petPreference': 'Cat-friendly',
    },
    {
      'name': 'David Okonkwo',
      'age': 32,
      'occupation': 'Software Engineer',
      'matchPercentage': 88,
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
      'location': 'Abuja',
      'religion': 'Muslim',
      'income': '₦500k - ₦700k/yr',
      'interests': ['Coding', 'Gaming', 'Hiking'],
      'bio':
          'Tech professional who works from home most days. Looking for a quiet space with good internet and respectful roommates.',
      'moveInDate': 'September 15',
      'preferredRent': '₦300k - ₦400k',
      'smokingPreference': 'Non-smoker',
      'petPreference': 'Pet-friendly',
    },
    {
      'name': 'Amina Bello',
      'age': 26,
      'occupation': 'Marketing Specialist',
      'matchPercentage': 85,
      'image': 'https://images.unsplash.com/photo-1589571894960-20bbe2828d0a',
      'location': 'Lagos',
      'religion': 'Muslim',
      'income': '₦300k - ₦450k/yr',
      'interests': ['Photography', 'Travel', 'Cooking'],
      'bio':
          'Creative marketing professional who loves to explore new places. Looking for a roommate who is open-minded and respectful.',
      'moveInDate': 'August 30',
      'preferredRent': '₦200k - ₦300k',
      'smokingPreference': 'Non-smoker',
      'petPreference': 'No pets',
    },
    {
      'name': 'Chinedu Eze',
      'age': 29,
      'occupation': 'Architect',
      'matchPercentage': 82,
      'image': 'https://images.unsplash.com/photo-1463453091185-61582044d556',
      'location': 'Calabar',
      'religion': 'Christian',
      'income': '₦450k - ₦600k/yr',
      'interests': ['Design', 'Art', 'Basketball'],
      'bio':
          'Creative architect who appreciates aesthetics and organization. Looking for a living space that allows for some creative expression.',
      'moveInDate': 'October 1',
      'preferredRent': '₦250k - ₦350k',
      'smokingPreference': 'Smoker (outdoors only)',
      'petPreference': 'Pet-friendly',
    },
  ];

  // Mock data for available properties
  final availableProperties = <Map<String, dynamic>>[
    {
      'title': 'Modern Apartment with City View',
      'address': '123 Main St, Downtown',
      'price': 1200,
      'bedrooms': 2,
      'bathrooms': 1,
      'image': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267',
      'amenities': ['Gym', 'Pool', 'Parking'],
    },
    {
      'title': 'Cozy Studio near University',
      'address': '456 College Ave, Westside',
      'price': 850,
      'bedrooms': 1,
      'bathrooms': 1,
      'image': 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688',
      'amenities': ['Furnished', 'Utilities Included', 'Laundry'],
    },
    {
      'title': 'Spacious Townhouse with Garden',
      'address': '789 Park Rd, Midtown',
      'price': 1500,
      'bedrooms': 3,
      'bathrooms': 2,
      'image': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750',
      'amenities': ['Backyard', 'Garage', 'Fireplace'],
    },
  ];

  // Mock data for recent messages
  final recentMessages = <Map<String, dynamic>>[
    {
      'sender': 'Sarah Johnson',
      'message':
          'Hi! I saw we matched as potential roommates. Would love to chat!',
      'time': '10:30 AM',
      'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
      'unread': true,
    },
    {
      'sender': 'Michael Chen',
      'message': 'When would you be looking to move in?',
      'time': 'Yesterday',
      'image': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
      'unread': false,
    },
    {
      'sender': 'Emma Rodriguez',
      'message':
          'I have a viewing scheduled for that apartment tomorrow if you want to join.',
      'time': 'Aug 7',
      'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
      'unread': false,
    },
  ];
}
