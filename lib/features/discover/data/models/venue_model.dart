class VenueReview {
  final String author;
  final double rating;
  final String comment;
  final String timeAgo;

  VenueReview({
    required this.author,
    required this.rating,
    required this.comment,
    required this.timeAgo,
  });
}

class VenueModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String location;
  final String moodTag; // 'work', 'social', 'inspiration', 'chill'
  final List<String> tags;
  final List<String> menuItems;
  final List<VenueReview> reviews;
  final double latitude;
  final double longitude;

  VenueModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.moodTag,
    required this.tags,
    required this.menuItems,
    required this.reviews,
    required this.latitude,
    required this.longitude,
  });
}

// Zengin Mock Veri Seti (Kadıköy/Moda odaklı koordinatlarla)
final List<VenueModel> mockVenues = [
  VenueModel(
    id: '1',
    name: 'Mavrik Lab & Coffee',
    description: 'Yüksek hızlı fiber internet, prizli bireysel çalışma masaları ve ödüllü baristalarımızdan kahveler ile odağınızı en üst düzeye çıkaracak yeni nesil bir çalışma alanı.',
    imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?q=80&w=1000&auto=format&fit=crop',
    rating: 4.8,
    reviewCount: 142,
    location: 'Caferağa, Kadıköy',
    moodTag: 'work',
    tags: ['Süper Hızlı Wi-Fi', 'Bireysel Priz', 'Sessiz Oda', 'Nitelikli Kahve'],
    menuItems: ['Cortado', 'Flat White', 'Ekşi Mayalı Kruvasan', 'Matcha Latte'],
    reviews: [
      VenueReview(author: 'Buse T.', rating: 5.0, comment: 'İnternet hızı inanılmaz (200 Mbps). Çalışma ortamı çok odaklayıcı.', timeAgo: '2 gün önce'),
      VenueReview(author: 'Kaan Y.', rating: 4.5, comment: 'Kahveleri başarılı ancak öğleden sonra yer bulmak biraz zorlaşıyor.', timeAgo: '1 hafta önce'),
    ],
    latitude: 40.9922,
    longitude: 29.0260,
  ),
  VenueModel(
    id: '2',
    name: 'Basta Social Cafe',
    description: 'Büyük yeşil bahçesi, ortak paylaşım masaları ve samimi tasarımıyla arkadaşlarınızla bir araya gelmek, derin sohbetler etmek için mükemmel bir sosyal mekân.',
    imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?q=80&w=1000&auto=format&fit=crop',
    rating: 4.6,
    reviewCount: 320,
    location: 'Moda, Kadıköy',
    moodTag: 'social',
    tags: ['Açık Bahçe', 'Canlı Müzik', 'Evcil Hayvan Dostu', 'Geniş Oturma Alanı'],
    menuItems: ['Basta Burger', 'Ev Yapımı Limonata', 'Lotus Cheesecake', 'Cold Brew'],
    reviews: [
      VenueReview(author: 'Mert A.', rating: 5.0, comment: 'Arkadaşlarla toplanmak için Moda\'daki en iyi bahçe. Atmosfer cıvıl cıvıl.', timeAgo: '3 gün önce'),
      VenueReview(author: 'Ece S.', rating: 4.0, comment: 'Tasarımı çok hoş, müzikler biraz yüksek sesli ama sohbeti engellemiyor.', timeAgo: '5 gün önce'),
    ],
    latitude: 40.9862,
    longitude: 29.0245,
  ),
  VenueModel(
    id: '3',
    name: 'Galeri 1888 Bistro',
    description: 'Yüksek tavanlı tarihi bir binada, çağdaş sanat eserleri ve loş neon ışıkların eşlik ettiği caz esintili bir yaratıcılık mabedi. Fikirlerinize ilham verecek özel bir atmosfer.',
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=1000&auto=format&fit=crop',
    rating: 4.9,
    reviewCount: 98,
    location: 'Caferağa, Kadıköy',
    moodTag: 'inspiration',
    tags: ['Sanat Galerisi', 'Loş Aydınlatma', 'Caz Çalma Listesi', 'Tasarım Kokteyller'],
    menuItems: ['1888 Signature', 'Truffle Fries', 'San Sebastian', 'Negroni'],
    reviews: [
      VenueReview(author: 'Deniz G.', rating: 5.0, comment: 'Burada vakit geçirirken insanın bir şeyler üretesi geliyor. Müzik seçimi harika.', timeAgo: '1 gün önce'),
      VenueReview(author: 'Selim K.', rating: 4.8, comment: 'Karaköy\'ün karmaşasından uzakta, çok şık bir sığınak.', timeAgo: '2 hafta önce'),
    ],
    latitude: 40.9885,
    longitude: 29.0310,
  ),
  VenueModel(
    id: '4',
    name: 'Vaha Botanical Oasis',
    description: 'Egzotik bitkilerle çevrili cam sera tasarımı, dinlendirici su sesleri ve organik bitki çayları koleksiyonu ile şehrin tüm stresini dışarıda bırakıp kafa dinleyeceğiniz bir vaha.',
    imageUrl: 'https://images.unsplash.com/photo-1445116572660-236099ec97a0?q=80&w=1000&auto=format&fit=crop',
    rating: 4.7,
    reviewCount: 184,
    location: 'Moda, Kadıköy',
    moodTag: 'chill',
    tags: ['Bitki Serası', 'Dinlendirici Müzik', 'Kitaplık Köşesi', 'Organik Menü'],
    menuItems: ['Detox Yeşil Çay', 'Avokado Poşe Yumurta', 'Glutensiz Kek', 'Kombucha'],
    reviews: [
      VenueReview(author: 'Melis U.', rating: 5.0, comment: 'Kitabımı alıp saatlerce oturduğum, bitkiler arasında kaybolduğum huzurlu yer.', timeAgo: '4 gün önce'),
      VenueReview(author: 'Onur D.', rating: 4.4, comment: 'Doğa ile iç içe hissettiriyor. Hafta sonu sakinleşmek için birebir.', timeAgo: '1 hafta önce'),
    ],
    latitude: 40.9812,
    longitude: 29.0290,
  ),
];
