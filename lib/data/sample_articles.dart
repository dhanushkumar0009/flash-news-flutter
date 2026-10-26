import '../models/article.dart';

/// Categories shown as chips on the home screen. "All" is not a real category -
/// it is the "no filter" option, handled in HomeScreen.
const List<String> kCategories = <String>[
  'All',
  'World',
  'Business',
  'Technology',
  'Sports',
  'Entertainment',
  'Health',
];

/// The app is frontend-only, so every story lives here. Built once at startup
/// because the timestamps are relative to "now".
final List<Article> kArticles = _buildArticles();

String _image(String seed) => 'https://picsum.photos/seed/$seed/800/450';

List<Article> _buildArticles() {
  final DateTime now = DateTime.now();
  DateTime hoursAgo(int hours) => now.subtract(Duration(hours: hours));

  return <Article>[
    Article(
      id: 'a01',
      title: 'India and Japan sign expanded clean energy partnership',
      description:
          'The agreement covers green hydrogen, grid storage and joint research funding over the next five years.',
      body:
          'The two governments described the agreement as the widest energy cooperation signed between them so far. '
          'It commits both sides to joint research centres, shared manufacturing standards for grid-scale batteries, '
          'and a financing window for green hydrogen pilots.\n\n'
          'Officials said the first projects would be announced within six months, with an initial focus on industrial '
          'clusters in Gujarat and Tamil Nadu. Analysts noted that the manufacturing standards clause may matter more '
          'in the long run than the headline funding figure, because it determines whose equipment can be used.',
      category: 'World',
      source: 'The Hindu',
      publishedAt: hoursAgo(2),
      imageUrl: _image('energy-summit'),
      url: 'https://www.thehindu.com/',
      isBreaking: true,
    ),
    Article(
      id: 'a02',
      title: 'Monsoon withdrawal begins across north-west India',
      description:
          'The weather department confirmed the retreat has started, two days later than the long-period average.',
      body:
          'The withdrawal line now runs across parts of Rajasthan and Punjab, the weather department said in its daily '
          'bulletin. Rainfall for the season closed slightly above the long-period average in most subdivisions.\n\n'
          'Farmers in the region have been advised to plan sowing around the drier spell expected over the next ten days. '
          'Reservoir levels across the north-west remain comfortable compared with the same week last year.',
      category: 'World',
      source: 'Hindustan Times',
      publishedAt: hoursAgo(5),
      imageUrl: _image('monsoon-fields'),
      url: 'https://www.hindustantimes.com/',
    ),
    Article(
      id: 'a03',
      title: 'UN climate panel moves annual review to Nairobi',
      description:
          'Delegates agreed the change would widen participation from countries most affected by rising temperatures.',
      body:
          'The decision followed two days of procedural debate. Supporters argued that holding the review in Nairobi '
          'reduces travel costs for smaller delegations that have struggled to attend sessions held in Europe.\n\n'
          'A smaller group of delegations raised concerns about meeting infrastructure, which the secretariat said had '
          'already been assessed. The next review is scheduled for March.',
      category: 'World',
      source: 'Reuters',
      publishedAt: hoursAgo(9),
      imageUrl: _image('un-assembly'),
      url: 'https://www.reuters.com/',
    ),
    Article(
      id: 'a04',
      title: 'Coastal states begin joint mangrove restoration drive',
      description:
          'Four states will share satellite monitoring data to track replanted areas along the eastern coastline.',
      body:
          'The programme sets a combined target of restoring degraded mangrove cover over three planting seasons. '
          'Shared satellite monitoring is the part officials called genuinely new, because earlier efforts were measured '
          'state by state with incompatible methods.\n\n'
          'Local fishing cooperatives have been included in the monitoring committees, a change requested after earlier '
          'plantation drives recorded poor survival rates.',
      category: 'World',
      source: 'Indian Express',
      publishedAt: hoursAgo(14),
      imageUrl: _image('mangrove-coast'),
      url: 'https://indianexpress.com/',
    ),
    Article(
      id: 'a05',
      title: 'Rupee steadies after three sessions of decline',
      description:
          'Traders pointed to softer crude prices and steady foreign inflows into domestic equities.',
      body:
          'The currency recovered part of the previous week loss in early trade before settling in a narrow band. '
          'Dealers said the central bank was not seen intervening heavily, suggesting the move was driven by flows '
          'rather than policy.\n\n'
          'Importers used the pause to cover near-term requirements. Market participants expect the range to hold '
          'until the next set of inflation figures.',
      category: 'Business',
      source: 'Mint',
      publishedAt: hoursAgo(3),
      imageUrl: _image('rupee-market'),
      url: 'https://www.livemint.com/',
      isBreaking: true,
    ),
    Article(
      id: 'a06',
      title: 'Small-cap funds see sharpest monthly inflow of the year',
      description:
          'Fund managers cautioned that valuations in parts of the segment have run ahead of earnings.',
      body:
          'Monthly data showed inflows concentrated in a handful of schemes. Several fund houses have already restricted '
          'lump-sum investments, citing difficulty deploying money at current prices.\n\n'
          'Advisers repeated the standard caution that the segment is volatile and unsuitable for short horizons. '
          'Redemption pressure during past corrections has tended to arrive quickly.',
      category: 'Business',
      source: 'The Economic Times',
      publishedAt: hoursAgo(7),
      imageUrl: _image('stock-charts'),
      url: 'https://economictimes.indiatimes.com/',
    ),
    Article(
      id: 'a07',
      title: 'Logistics firm plans 40 new warehouses near tier-two cities',
      description:
          'The expansion follows sustained growth in online orders outside the eight largest metropolitan areas.',
      body:
          'The company said the sites would be smaller than its existing hubs but placed closer to customers, cutting '
          'last-mile delivery times. Construction is expected to begin in the next quarter.\n\n'
          'Industry observers linked the plan to a wider shift in online retail, where order growth has been faster '
          'outside the largest cities for several consecutive quarters.',
      category: 'Business',
      source: 'Business Standard',
      publishedAt: hoursAgo(16),
      imageUrl: _image('warehouse-logistics'),
      url: 'https://www.business-standard.com/',
    ),
    Article(
      id: 'a08',
      title: 'Banks asked to publish clearer fee disclosures',
      description:
          'The regulator wants charges presented in a standard format so customers can compare accounts directly.',
      body:
          'Under the proposal, every retail account would carry a one-page summary listing charges in a fixed order. '
          'The regulator said inconsistent presentation had made comparison difficult even when the underlying fees '
          'were similar.\n\n'
          'Banks have been given until the end of the financial year to comply. Consumer groups welcomed the move but '
          'asked for the summary to be shown before an account is opened, not only afterwards.',
      category: 'Business',
      source: 'Mint',
      publishedAt: hoursAgo(21),
      imageUrl: _image('bank-counter'),
      url: 'https://www.livemint.com/',
    ),
    Article(
      id: 'a09',
      title: 'On-device translation arrives on mid-range Android phones',
      description:
          'The feature runs without an internet connection and supports eleven Indian languages at launch.',
      body:
          'The models are small enough to run on phones with 6 GB of memory, which brings the feature well below the '
          'flagship tier where it first appeared. Translation happens entirely on the device, so text never leaves '
          'the phone.\n\n'
          'Developers can call the same models through a system API. Early testers reported noticeably better results '
          'for short conversational text than for long formal documents.',
      category: 'Technology',
      source: 'Mashable',
      publishedAt: hoursAgo(1),
      imageUrl: _image('android-phone'),
      url: 'https://mashable.com/',
      isBreaking: true,
    ),
    Article(
      id: 'a10',
      title: 'Open-source browser engine reaches first stable release',
      description:
          'The project has been in development for six years and targets low-powered hardware.',
      body:
          'The team described the release as feature-complete for everyday browsing rather than a replacement for '
          'established engines. Memory use is its clearest advantage, particularly on devices with limited RAM.\n\n'
          'Several Linux distributions have said they will package it as an alternative browser. The project is funded '
          'by donations and a small set of institutional sponsors.',
      category: 'Technology',
      source: 'The Verge',
      publishedAt: hoursAgo(6),
      imageUrl: _image('open-source-code'),
      url: 'https://www.theverge.com/',
    ),
    Article(
      id: 'a11',
      title: 'Researchers cut training cost for speech models by half',
      description:
          'The method reuses intermediate representations instead of recomputing them at every step.',
      body:
          'The paper reports comparable accuracy on standard benchmarks at roughly half the compute budget. The authors '
          'released code alongside the paper, which several independent groups have already reproduced.\n\n'
          'The approach matters most for languages with limited training data, where the cost of experimentation has '
          'been the practical barrier rather than model design.',
      category: 'Technology',
      source: 'Ars Technica',
      publishedAt: hoursAgo(11),
      imageUrl: _image('ai-research-lab'),
      url: 'https://arstechnica.com/',
    ),
    Article(
      id: 'a12',
      title: 'India crosses one billion monthly digital payments',
      description:
          'Small-value transactions drove most of the growth, according to the latest settlement data.',
      body:
          'The milestone was reached a quarter earlier than most forecasts. Average transaction value fell again, '
          'continuing a trend that suggests digital payments are replacing cash for everyday purchases rather than '
          'only large ones.\n\n'
          'Merchant adoption in smaller towns showed the steepest increase. Operators said reliability during peak '
          'hours remains the main engineering challenge.',
      category: 'Technology',
      source: 'The Times of India',
      publishedAt: hoursAgo(19),
      imageUrl: _image('digital-payment'),
      url: 'https://timesofindia.indiatimes.com/',
    ),
    Article(
      id: 'a13',
      title: 'India seal series win with clinical bowling display',
      description:
          'A disciplined spell in the middle overs left the chase stranded well short of the target.',
      body:
          'The bowlers conceded only twenty-three runs in a ten-over stretch, squeezing out the partnership that had '
          'threatened to take the game away. Two wickets in the same over effectively ended the contest.\n\n'
          'The captain singled out the fielding effort afterwards, pointing to two run-outs that came from direct hits. '
          'The final match of the series begins on Sunday.',
      category: 'Sports',
      source: 'ESPNcricinfo',
      publishedAt: hoursAgo(4),
      imageUrl: _image('cricket-stadium'),
      url: 'https://www.espncricinfo.com/',
      isBreaking: true,
    ),
    Article(
      id: 'a14',
      title: 'Teenage sprinter breaks national junior record',
      description:
          'The seventeen-year-old took almost a tenth of a second off a mark that had stood for nine years.',
      body:
          'The run came in the semi-final rather than the final, which the athlete also won comfortably. Coaches said '
          'the start was the clearest improvement over the past season.\n\n'
          'The federation confirmed the time would be submitted for ratification. Qualification standards for next '
          'year continental meet are now within reach.',
      category: 'Sports',
      source: 'Sportstar',
      publishedAt: hoursAgo(8),
      imageUrl: _image('athletics-track'),
      url: 'https://sportstar.thehindu.com/',
    ),
    Article(
      id: 'a15',
      title: 'City hold league leaders to a goalless draw',
      description:
          'A compact defensive shape frustrated the visitors, who managed only two shots on target.',
      body:
          'The home side dropped deep from the opening whistle and defended the width of the penalty area rather than '
          'the full pitch. It worked: the leaders struggled to create anything from open play.\n\n'
          'Both managers described the point as useful. The result keeps the gap at the top unchanged with nine '
          'fixtures remaining.',
      category: 'Sports',
      source: 'Goal',
      publishedAt: hoursAgo(13),
      imageUrl: _image('football-match'),
      url: 'https://www.goal.com/',
    ),
    Article(
      id: 'a16',
      title: 'Chess prodigy qualifies for candidates tournament',
      description:
          'A final-round draw with black was enough to secure the qualifying spot on tiebreak.',
      body:
          'The qualification was mathematically secure before the final round began, but only by the narrowest of '
          'margins. A loss would have opened the door to two rivals.\n\n'
          'The player described the tournament as the most consistent of their career so far, pointing to the absence '
          'of a single loss across eleven games.',
      category: 'Sports',
      source: 'Sportstar',
      publishedAt: hoursAgo(26),
      imageUrl: _image('chess-board'),
      url: 'https://sportstar.thehindu.com/',
    ),
    Article(
      id: 'a17',
      title: 'Independent film takes top prize at regional festival',
      description:
          'The jury praised a debut feature shot over fourteen months on a modest budget.',
      body:
          'The film follows three generations of a family in a coastal town and was made largely with a non-professional '
          'cast. The director said the long shooting schedule was a consequence of funding arriving in instalments.\n\n'
          'Distributors have picked it up for a limited theatrical release before it moves to streaming early next year.',
      category: 'Entertainment',
      source: 'Film Companion',
      publishedAt: hoursAgo(10),
      imageUrl: _image('film-festival'),
      url: 'https://www.filmcompanion.in/',
    ),
    Article(
      id: 'a18',
      title: 'Streaming service commissions four regional originals',
      description:
          'The slate covers Tamil, Bengali, Marathi and Malayalam productions due next year.',
      body:
          'Executives said regional originals have outperformed dubbed content on the platform for three consecutive '
          'quarters, and the commissioning budget has been shifted accordingly.\n\n'
          'Two of the four titles come from first-time showrunners. Production begins in the next quarter.',
      category: 'Entertainment',
      source: 'Variety',
      publishedAt: hoursAgo(15),
      imageUrl: _image('film-studio'),
      url: 'https://variety.com/',
    ),
    Article(
      id: 'a19',
      title: 'Veteran playback singer announces farewell concert tour',
      description:
          'The six-city tour will close a recording career spanning more than four decades.',
      body:
          'The singer said the decision had been made some time ago and described the tour as a thank-you rather than '
          'a retirement announcement, confirming that studio work would continue occasionally.\n\n'
          'Tickets for the opening night sold out within hours. Additional dates are under consideration.',
      category: 'Entertainment',
      source: 'Rolling Stone India',
      publishedAt: hoursAgo(23),
      imageUrl: _image('concert-stage'),
      url: 'https://rollingstoneindia.com/',
    ),
    Article(
      id: 'a20',
      title: 'Animation studio opens training centre for new graduates',
      description:
          'The programme will take sixty students a year and guarantees a paid internship on completion.',
      body:
          'The studio said the centre was a response to a persistent shortage of trained animators, particularly in '
          'rigging and lighting, which it had been filling with overseas contractors.\n\n'
          'Applications open next month and are not restricted to design graduates. The first cohort begins in June.',
      category: 'Entertainment',
      source: 'Animation Xpress',
      publishedAt: hoursAgo(30),
      imageUrl: _image('animation-studio'),
      url: 'https://www.animationxpress.com/',
    ),
    Article(
      id: 'a21',
      title: 'Large trial finds walking breaks lower blood pressure',
      description:
          'Participants who broke up long sitting periods every half hour showed measurable improvements.',
      body:
          'The trial followed just over two thousand office workers for six months. Those assigned short walking breaks '
          'recorded lower average readings than the control group, with the effect strongest among participants who '
          'began with elevated pressure.\n\n'
          'Researchers cautioned that the study measured a single outcome and cannot speak to long-term cardiovascular '
          'risk. A follow-up is planned.',
      category: 'Health',
      source: 'BBC Health',
      publishedAt: hoursAgo(12),
      imageUrl: _image('walking-health'),
      url: 'https://www.bbc.com/news/health',
    ),
    Article(
      id: 'a22',
      title: 'District hospitals get expanded diagnostic equipment',
      description:
          'The rollout adds imaging and laboratory capacity at facilities that previously referred patients onward.',
      body:
          'The programme covers sixty district hospitals in its first phase. Officials said the aim is to reduce travel '
          'for routine diagnostics, which has been a recurring complaint in rural health surveys.\n\n'
          'Staff training has been scheduled alongside installation, after an earlier equipment drive left machines '
          'unused for months in several districts.',
      category: 'Health',
      source: 'The Hindu',
      publishedAt: hoursAgo(18),
      imageUrl: _image('hospital-equipment'),
      url: 'https://www.thehindu.com/',
    ),
    Article(
      id: 'a23',
      title: 'Nutritionists urge clearer front-of-pack food labelling',
      description:
          'A proposed star rating would summarise sugar, salt and fat content in one visible mark.',
      body:
          'Supporters argue that existing nutrition panels are read by a small minority of shoppers and are positioned '
          'where they are easy to ignore. The proposed mark would appear on the front of the package.\n\n'
          'Parts of the food industry have asked for a longer transition period, citing packaging redesign costs. '
          'A consultation closes next month.',
      category: 'Health',
      source: 'Down To Earth',
      publishedAt: hoursAgo(28),
      imageUrl: _image('food-labels'),
      url: 'https://www.downtoearth.org.in/',
    ),
    Article(
      id: 'a24',
      title: 'Sleep study links irregular bedtimes to daytime fatigue',
      description:
          'Consistency of sleep timing mattered more than total hours slept, researchers reported.',
      body:
          'The study tracked sleep timing in university students over one semester. Those with the most variable '
          'bedtimes reported the highest fatigue scores, even when their average sleep duration was adequate.\n\n'
          'The authors suggested that advice focused only on sleeping longer may miss the more achievable change of '
          'sleeping at the same time each night.',
      category: 'Health',
      source: 'BBC Health',
      publishedAt: hoursAgo(34),
      imageUrl: _image('sleep-study'),
      url: 'https://www.bbc.com/news/health',
    ),
  ];
}
