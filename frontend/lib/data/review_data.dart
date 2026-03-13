// ignore_for_file: lines_longer_than_80_chars
import 'package:smart_ecommerce_app/models/data_models.dart';

/// Pre-written seed reviews for products gen_1 – gen_113.
/// Products gen_114 – gen_143 intentionally have no seed reviews.
class ReviewData {
  ReviewData._();

  static Review _r(String id, String user, double stars, String text, String date) =>
      Review(id: id, userName: user, rating: stars, comment: text, date: DateTime.parse(date));

  static final Map<String, List<Review>> seedReviews = {
    'gen_1': [
      _r('r1_1','Zain Ahmed',5,'Excellent quality polo! Fabric is soft and the fit is just right.','2025-01-10'),
      _r('r1_2','Atif Malik',4,'Very comfortable for daily wear. Colour did not fade after washing.','2025-02-03'),
    ],
    'gen_2': [
      _r('r2_1','Ahmed Raza',5,'Loved the stitching quality. Wearing it to university every week.','2025-01-15'),
      _r('r2_2','Hasan Siddiqui',4,'Great polo, slight colour difference from pictures but still nice.','2025-02-20'),
    ],
    'gen_3': [
      _r('r3_1','Aoon Ali',5,'Premium feel for the price. Highly recommend to everyone.','2025-01-22'),
      _r('r3_2','Bilal Khan',4,'Good fit and comfortable material. Will order more colours.','2025-02-11'),
      _r('r3_3','Usman Tariq',5,'Perfect gift for Eid. Everyone loved it!','2025-03-01'),
    ],
    'gen_4': [
      _r('r4_1','Saad Iqbal',4,'Nice tee, fabric is breathable and cool in summer.','2025-01-18'),
      _r('r4_2','Faisal Rehman',5,'Best tee I have bought online. Fast delivery too.','2025-02-14'),
    ],
    'gen_5': [
      _r('r5_1','Junaid Anwar',4,'Decent quality. Size runs slightly large so order one size down.','2025-01-28'),
      _r('r5_2','Hamza Shah',5,'Great value for money. Colour is exactly as shown.','2025-02-25'),
    ],
    'gen_6': [
      _r('r6_1','Talha Butt',5,'Amazing graphic tee. Got so many compliments.','2025-01-30'),
      _r('r6_2','Imran Qureshi',4,'Good print quality, does not crack after wash.','2025-02-08'),
    ],
    'gen_7': [
      _r('r7_1','Omer Farouk',5,'Formal shirt stitching is immaculate. Perfect for office.','2025-01-12'),
      _r('r7_2','Adeel Chaudhry',4,'Very professional look. Material is slightly thin but okay.','2025-02-17'),
      _r('r7_3','Naveed Hussain',5,'Wore this to an interview and felt very confident!','2025-03-02'),
    ],
    'gen_8': [
      _r('r8_1','Rizwan Gillani',4,'Classic formal shirt. Buttons are solid, no loose threads.','2025-01-25'),
      _r('r8_2','Kamran Sheikh',5,'Excellent finish. Will definitely buy again.','2025-02-22'),
    ],
    'gen_9': [
      _r('r9_1','Shoaib Noor',5,'Love this shirt. Wore it to a wedding and looked sharp.','2025-01-08'),
      _r('r9_2','Asad Mehmood',4,'Good quality but needs ironing. Overall happy with purchase.','2025-02-19'),
    ],
    'gen_10': [
      _r('r10_1','Waqar Baig',5,'Jeans fit perfectly. Denim is thick and durable.','2025-01-14'),
      _r('r10_2','Toqeer Amjad',4,'Great jeans for casual outing. Comfortable waistband.','2025-02-06'),
    ],
    'gen_11': [
      _r('r11_1','Khurram Awan',5,'Best denim I have worn. Stretch fabric makes it so comfortable.','2025-01-20'),
      _r('r11_2','Yasir Lone',4,'Nice colour and cut. Zip quality could be better but overall good.','2025-02-15'),
      _r('r11_3','Asim Rauf',5,'Ordered medium and fits perfectly. Highly recommend.','2025-03-04'),
    ],
    'gen_12': [
      _r('r12_1','Farhan Akram',4,'Slim fit looks great. Comfortable for all-day wear.','2025-01-26'),
      _r('r12_2','Mohsin Javed',5,'Premium denim quality. Worth every rupee.','2025-02-23'),
    ],
    'gen_13': [
      _r('r13_1','Raza Haider',5,'Chinos are perfect for casual and semi-formal looks.','2025-01-17'),
      _r('r13_2','Sohail Mirza',4,'Good stitching, comfortable fabric. Slight colour variation.','2025-02-12'),
    ],
    'gen_14': [
      _r('r14_1','Danish Riaz',5,'Love these chinos. Pairs well with any shirt.','2025-01-23'),
      _r('r14_2','Aamir Shafiq',4,'Great fit. Material is a bit heavy but looks premium.','2025-02-28'),
      _r('r14_3','Zubair Naeem',5,'Bought two pairs, will buy more. Excellent!','2025-03-05'),
    ],
    'gen_15': [
      _r('r15_1','Fahad Cheema',4,'Good shorts for summer. Breathable and lightweight.','2025-01-29'),
      _r('r15_2','Hamid Irfan',5,'Perfect beach shorts. Very comfortable.','2025-02-16'),
    ],
    'gen_16': [
      _r('r16_1','Jawad Latif',5,'Comfortable shorts, elastic waistband works great.','2025-01-11'),
      _r('r16_2','Umar Saleem',4,'Good quality but pocket stitching is a bit weak.','2025-02-04'),
    ],
    'gen_17': [
      _r('r17_1','Bilal Asghar',5,'Jacket is heavy-duty and warm. Perfect for winter.','2025-01-16'),
      _r('r17_2','Saad Munir',4,'Nice jacket but zipper is a bit stiff initially.','2025-02-21'),
      _r('r17_3','Fawad Sultan',5,'Best winter jacket I have owned. Very warm!','2025-03-06'),
    ],
    'gen_18': [
      _r('r18_1','Tahir Mahmood',4,'Good blazer for formal events. Fits well.','2025-01-19'),
      _r('r18_2','Naeem Qureshi',5,'Excellent blazer quality. Perfect for job interviews.','2025-02-07'),
    ],
    'gen_19': [
      _r('r19_1','Waseem Akbar',5,'Hoodie is super soft and warm. Love the fit.','2025-01-27'),
      _r('r19_2','Ali Hassan',4,'Nice hoodie but hood drawstrings are slightly uneven.','2025-02-24'),
    ],
    'gen_20': [
      _r('r20_1','Rehan Baig',5,'Best hoodie this winter. Very cozy inside.','2025-01-13'),
      _r('r20_2','Zafar Iqbal',4,'Warm and comfortable. Will order in another colour.','2025-02-09'),
      _r('r20_3','Sarfraz Ahmed',5,'Great quality hoodie. Fast delivery!','2025-03-03'),
    ],
    'gen_21': [
      _r('r21_1','Irfan Siddiq',5,'Shawl is incredibly soft and warm. Excellent for winter.','2025-01-21'),
      _r('r21_2','Nadeem Khalil',4,'Good quality shawl. Colour is vibrant as shown.','2025-02-18'),
    ],
    'gen_22': [
      _r('r22_1','Shahzad Rana',4,'Nice shawl texture. Warm enough for chilly mornings.','2025-01-24'),
      _r('r22_2','Arshad Bhatti',5,'Premium feel. Gifted to my father and he loved it.','2025-02-13'),
    ],
    'gen_23': [
      _r('r23_1','Tariq Aziz',5,'Sweater quality is top-notch. Not scratchy at all.','2025-01-09'),
      _r('r23_2','Pervez Mirza',4,'Warm and cozy. Size chart is accurate.','2025-02-05'),
      _r('r23_3','Mukhtar Ali',5,'My go-to winter sweater now. Excellent!','2025-03-01'),
    ],
    'gen_24': [
      _r('r24_1','Ghous Bux',4,'Good sweater quality. Slightly thick for indoors.','2025-01-31'),
      _r('r24_2','Ejaz Ahmad',5,'Worth every penny. Super warm!','2025-02-26'),
    ],
    'gen_25': [
      _r('r25_1','Kashif Baloch',5,'Sweatshirt is perfect for casual daily wear.','2025-01-15'),
      _r('r25_2','Aqeel Abbas',4,'Good fabric, comfortable fit. Would recommend.','2025-02-10'),
    ],
    'gen_26': [
      _r('r26_1','Mubashir Gill',5,'Muffler is super soft and cozy. Great winter accessory.','2025-01-22'),
      _r('r26_2','Salman Chishti',4,'Nice muffler. Keeps neck very warm in cold weather.','2025-02-17'),
    ],
    'gen_27': [
      _r('r27_1','Jamshed Bajwa',5,'Kameez Shalwar stitching is excellent. Traditional and elegant.','2025-01-28'),
      _r('r27_2','Kamal Din',4,'Beautiful embroidery on neckline. Very comfortable fabric.','2025-02-23'),
      _r('r27_3','Bashir Ahmad',5,'Ordered for Eid and got so many compliments!','2025-03-05'),
    ],
    'gen_28': [
      _r('r28_1','Zarak Khan',4,'Good traditional outfit. Fabric is smooth and not heavy.','2025-01-16'),
      _r('r28_2','Anwar Saeed',5,'Very authentic look. Fits perfectly as per size chart.','2025-02-11'),
    ],
    'gen_29': [
      _r('r29_1','Nisar Abbasi',5,'Excellent kameez quality. Shalwar stitching is neat.','2025-01-19'),
      _r('r29_2','Riaz Ahmed',4,'Good value. Nice for casual and formal wear.','2025-02-14'),
    ],
    'gen_30': [
      _r('r30_1','Shabbir Kazmi',5,'Kurta Trouser set is simply stunning. Great fabric!','2025-01-25'),
      _r('r30_2','Aslam Noor',4,'Well stitched, comfortable and stylish. Happy with it.','2025-02-20'),
      _r('r30_3','Waqas Hafeez',5,'Gifted to my bhai for his birthday. He loved it!','2025-03-02'),
    ],
    'gen_31': [
      _r('r31_1','Tahsin Raza',4,'Nice kurta trouser. Traditional yet modern design.','2025-01-30'),
      _r('r31_2','Murad Hussain',5,'Beautiful outfit. Fabric quality is superb.','2025-02-27'),
    ],
    'gen_32': [
      _r('r32_1','Umer Daud',5,'Kurta trouser fit is spot on. Comfortable for all day.','2025-01-12'),
      _r('r32_2','Danyal Farooq',4,'Nice embroidery details. Good value for price.','2025-02-08'),
    ],
    'gen_33': [
      _r('r33_1','Haroon Zaman',5,'Unstitched fabric quality is exceptional. Fine weave.','2025-01-18'),
      _r('r33_2','Qasim Butt',4,'Colour is exactly as shown. Will stitch it soon.','2025-02-13'),
      _r('r33_3','Yousaf Sherani',5,'Best unstitched fabric I bought online. Very satisfied.','2025-03-04'),
    ],
    'gen_34': [
      _r('r34_1','Attaur Rehman',4,'Good fabric texture. My tailor confirmed the quality.','2025-01-23'),
      _r('r34_2','Manzoor Shah',5,'Premium fabric at a great price. Will buy more.','2025-02-19'),
    ],
    'gen_35': [
      _r('r35_1','Nasrullah Khan',5,'Casual shoes are super comfortable. No heel pain at all.','2025-01-27'),
      _r('r35_2','Imdad Ali',4,'Good build quality. Sole is thick and durable.','2025-02-24'),
    ],
    'gen_36': [
      _r('r36_1','Gulshan Mehdi',5,'Comfort shoes are exactly what I needed. Great support.','2025-01-14'),
      _r('r36_2','Safdar Zaidi',4,'Comfortable for long walks. Slightly narrow but fine.','2025-02-09'),
      _r('r36_3','Ikram Butt',5,'Ordered for my daily commute. Feet feel great all day.','2025-03-01'),
    ],
    'gen_37': [
      _r('r37_1','Shujaat Ahmed',4,'Sandals are sturdy. Strap quality is good.','2025-01-20'),
      _r('r37_2','Liaqat Baloch',5,'Perfect summer sandals for Pakistan heat!','2025-02-16'),
    ],
    'gen_38': [
      _r('r38_1','Mazhar Hussain',5,'Sneakers look amazing. Very comfortable for sports.','2025-01-11'),
      _r('r38_2','Aftab Alam',4,'Good sneakers, cushioning is great. Laces could be better.','2025-02-06'),
    ],
    'gen_39': [
      _r('r39_1','Rahat Fateh',5,'Formal shoes are very classy. Leather-look finish is great.','2025-01-24'),
      _r('r39_2','Sabir Mehmood',4,'Professional looking shoes. Comfortable for office wear.','2025-02-21'),
      _r('r39_3','Zeeshan Amir',5,'My favourite formal shoes now. Excellent quality!','2025-03-06'),
    ],
    'gen_40': [
      _r('r40_1','Wasim Raja',4,'Nice sneakers for casual use. Sole is grippy.','2025-01-17'),
      _r('r40_2','Tanveer Gill',5,'Very stylish sneakers. Got many compliments at university.','2025-02-12'),
    ],
    'gen_41': [
      _r('r41_1','Khalid Mehmood',5,'Glasses look premium. Build is solid and fit is comfortable.','2025-01-29'),
      _r('r41_2','Naseem Baig',4,'Nice sunglasses. UV protection is good.','2025-02-25'),
    ],
    'gen_42': [
      _r('r42_1','Babar Azam',4,'Classic looking glasses. Nose pads are comfortable.','2025-01-13'),
      _r('r42_2','Shadab Khan',5,'Excellent build quality for the price. Love them!','2025-02-08'),
      _r('r42_3','Hassan Ali',5,'Wore these in Karachi sun and they are perfect!','2025-03-03'),
    ],
    'gen_43': [
      _r('r43_1','Fakhar Zaman',5,'Belt quality is top. Genuine leather feel.','2025-01-21'),
      _r('r43_2','Imam ul Haq',4,'Good belt. Buckle is solid and does not scratch.','2025-02-17'),
    ],
    'gen_44': [
      _r('r44_1','Haris Sohail',5,'Very stylish belt. Pairs well with formal trousers.','2025-01-26'),
      _r('r44_2','Asif Ali',4,'Decent quality. Slight smell of leather which fades.','2025-02-22'),
    ],
    'gen_45': [
      _r('r45_1','Mohammad Hafeez',5,'Cap fits perfectly. Adjustable strap works great.','2025-01-09'),
      _r('r45_2','Wahab Riaz',4,'Nice cap for summer. Good sun protection.','2025-02-04'),
      _r('r45_3','Abdur Rehman',5,'Stylish cap. Got compliments from my friends!','2025-03-02'),
    ],
    'gen_46': [
      _r('r46_1','Umar Gul',4,'Decent cap. Stitching is clean and embroidery is sharp.','2025-01-15'),
      _r('r46_2','Junaid Khan',5,'Love this cap. Looks great with casual outfits.','2025-02-10'),
    ],
    'gen_47': [
      _r('r47_1','Shoaib Akhtar',5,'Fragrance is very long lasting. Great for evenings.','2025-01-20'),
      _r('r47_2','Waqar Younis',4,'Nice scent. Not too strong, just right for daily use.','2025-02-15'),
    ],
    'gen_48': [
      _r('r48_1','Inzamam ul Haq',5,'Amazing perfume. Reminds me of oud from Arabia.','2025-01-27'),
      _r('r48_2','Younis Khan',4,'Good fragrance. Lasts around 6 hours on skin.','2025-02-23'),
      _r('r48_3','Misbah ul Haq',5,'Best perfume from this store so far. Will reorder!','2025-03-04'),
    ],
    'gen_49': [
      _r('r49_1','Azhar Ali',4,'Body spray is refreshing. Nice citrus notes.','2025-01-12'),
      _r('r49_2','Sarfraz Ahmed',5,'Great body spray for daily use. Long lasting!','2025-02-07'),
    ],
    'gen_50': [
      _r('r50_1','Mohammad Yousuf',5,'Excellent attar quality. Very authentic traditional scent.','2025-01-18'),
      _r('r50_2','Kamran Akmal',4,'Nice attar. A little goes a long way. Good value.','2025-02-13'),
    ],
    'gen_51': [
      _r('r51_1','Zain ul Abidin',5,'Polo quality is incredible. Collar stays stiff.','2025-01-24'),
      _r('r51_2','Amjad Sabri',4,'Great polo, comfortable and stylish.','2025-02-20'),
      _r('r51_3','Arif Lohar',5,'Perfect fit. Will definitely order again!','2025-03-01'),
    ],
    'gen_52': [
      _r('r52_1','Sahir Alt',4,'Good tee. Print is bold and does not fade easily.','2025-01-29'),
      _r('r52_2','Abrar ul Haq',5,'Bought three. All are great quality!','2025-02-26'),
    ],
    'gen_53': [
      _r('r53_1','Rahat Fateh Ali',5,'Premium formal shirt. Looks very sharp.','2025-01-11'),
      _r('r53_2','Nusrat Fateh Ali',4,'Good formal shirt. Button holes are clean.','2025-02-05'),
    ],
    'gen_54': [
      _r('r54_1','Strings Band',5,'Jeans quality is amazing. Colour did not bleed.','2025-01-17'),
      _r('r54_2','Noori Band',4,'Great jeans. Fit is slim and comfortable.','2025-02-12'),
      _r('r54_3','Fuzön Band',5,'Best jeans I have owned. Ordered in two colours.','2025-03-03'),
    ],
    'gen_55': [
      _r('r55_1','Jimmy Khan',4,'Denim is sturdy. Good blue shade.','2025-01-22'),
      _r('r55_2','Bilal Khan',5,'Fits great and looks stylish with any top.','2025-02-18'),
    ],
    'gen_56': [
      _r('r56_1','Ali Zafar',5,'Chinos are slim fit and very comfortable.','2025-01-28'),
      _r('r56_2','Atif Aslam',4,'Good quality chinos. Easy to wash and iron.','2025-02-25'),
    ],
    'gen_57': [
      _r('r57_1','Fawad Khan',5,'These shorts are perfect for casual weekends.','2025-01-14'),
      _r('r57_2','Hamza Ali Abbasi',4,'Comfortable shorts. Pockets are deep which is nice.','2025-02-09'),
      _r('r57_3','Humayun Saeed',5,'Great shorts for summer! Very light fabric.','2025-03-02'),
    ],
    'gen_58': [
      _r('r58_1','Ahad Raza Mir',4,'Jacket keeps me very warm. Perfect for Lahore winters.','2025-01-21'),
      _r('r58_2','Sheheryar Maqsood',5,'Premium jacket. Looks expensive but priced well.','2025-02-16'),
    ],
    'gen_59': [
      _r('r59_1','Mohsin Abbas',5,'Blazer fit is perfect. Wore it to a wedding reception.','2025-01-26'),
      _r('r59_2','Syed Jibran',4,'Nice blazer. Lining is smooth and comfortable.','2025-02-22'),
    ],
    'gen_60': [
      _r('r60_1','Adnan Siddiqui',5,'Hoodie is very cozy. Great for winter evenings.','2025-01-09'),
      _r('r60_2','Zaviyar Nauman',4,'Good hoodie quality. Drawstrings are even and clean.','2025-02-04'),
      _r('r60_3','Nauman Ijaz',5,'My whole family wanted one after seeing mine!','2025-03-01'),
    ],
    'gen_61': [
      _r('r61_1','Mikaal Zulfiqar',4,'Shawl is warm and lightweight. Good for evenings.','2025-01-15'),
      _r('r61_2','Asad Siddiqui',5,'Very fine shawl. Bought for my father and he loves it.','2025-02-10'),
    ],
    'gen_62': [
      _r('r62_1','Ahsan Khan',5,'Sweater is warm and not at all scratchy. Love it.','2025-01-20'),
      _r('r62_2','Danish Taimoor',4,'Good sweater. Slightly thick for indoors but perfect outside.','2025-02-15'),
    ],
    'gen_63': [
      _r('r63_1','Affan Waheed',5,'Sweatshirt comfort level is off the charts!','2025-01-27'),
      _r('r63_2','Muneeb Butt',4,'Great sweatshirt. Colour did not fade after first wash.','2025-02-23'),
      _r('r63_3','Emmad Irfani',5,'Bought this for winter and love it. Very cozy!','2025-03-05'),
    ],
    'gen_64': [
      _r('r64_1','Gohar Rasheed',4,'Muffler is soft and warm. Easy to style.','2025-01-12'),
      _r('r64_2','Noor ul Hassan',5,'Excellent muffler. My neck stays warm all day.','2025-02-07'),
    ],
    'gen_65': [
      _r('r65_1','Mohib Mirza',5,'Traditional kameez shalwar, beautifully stitched.','2025-01-18'),
      _r('r65_2','Faysal Qureshi',4,'Very authentic look. Comfortable fabric for sitting long.','2025-02-13'),
    ],
    'gen_66': [
      _r('r66_1','Shaan Shahid',5,'Kameez shalwar perfect for formal occasions.','2025-01-24'),
      _r('r66_2','Resham',4,'Nice stitching and good colour. Bought for Eid.','2025-02-20'),
      _r('r66_3','Meera Ji',5,'Gifted to my husband, he absolutely loved it!','2025-03-02'),
    ],
    'gen_67': [
      _r('r67_1','Saba Qamar',4,'Kurta trouser design is very elegant.','2025-01-29'),
      _r('r67_2','Mahira Khan',5,'Beautiful and comfortable. Perfect for formal events.','2025-02-26'),
    ],
    'gen_68': [
      _r('r68_1','Sajal Ali',5,'Excellent kurta quality. Fabric is breathable.','2025-01-11'),
      _r('r68_2','Yumna Zaidi',4,'Good fit, nice embroidery at cuffs. Recommended!','2025-02-05'),
    ],
    'gen_69': [
      _r('r69_1','Ayeza Khan',5,'Unstitched fabric is very fine. Smooth texture.','2025-01-17'),
      _r('r69_2','Hira Mani',4,'Nice colour options. Fabric feels premium.','2025-02-12'),
      _r('r69_3','Sana Javed',5,'Stitched it and the result was gorgeous!','2025-03-04'),
    ],
    'gen_70': [
      _r('r70_1','Hareem Shah',4,'Unstitched fabric good quality. Weave is tight and fine.','2025-01-22'),
      _r('r70_2','Neelam Muneer',5,'Great fabric. My tailor said it is very easy to work with.','2025-02-18'),
    ],
    'gen_71': [
      _r('r71_1','Iqra Aziz',5,'Casual shoes are so comfortable for all day.','2025-01-28'),
      _r('r71_2','Aiman Zaman',4,'Nice casual shoes. Sole grip is very good.','2025-02-24'),
    ],
    'gen_72': [
      _r('r72_1','Minal Khan',5,'Comfort shoes live up to their name. No pain at all.','2025-01-14'),
      _r('r72_2','Shiza Hasan',4,'Great support. Good for those who stand for long hours.','2025-02-09'),
      _r('r72_3','Sonya Hussyn',5,'Best shoes I bought online. Fast delivery too!','2025-03-01'),
    ],
    'gen_73': [
      _r('r73_1','Urwa Hocane',4,'Sandals are durable and stylish. Strap holds firmly.','2025-01-21'),
      _r('r73_2','Mawra Hocane',5,'Great sandals for summer. Beautifully designed.','2025-02-16'),
    ],
    'gen_74': [
      _r('r74_1','Armeena Khan',5,'Sneakers are trendy and comfortable. Love them!','2025-01-26'),
      _r('r74_2','Sadia Islam',4,'Nice looking sneakers. Laces are good quality.','2025-02-22'),
    ],
    'gen_75': [
      _r('r75_1','Nadia Hussain',5,'Formal shoes look very classy. Great for weddings.','2025-01-09'),
      _r('r75_2','Juggun Kazim',4,'Comfortable formal shoes. No heel pain even after hours.','2025-02-04'),
      _r('r75_3','Rubina Ashraf',5,'Premium quality. Ordered two pairs!','2025-03-02'),
    ],
    'gen_76': [
      _r('r76_1','Bushra Ansari',4,'Good sunglasses. UV protection confirmed in sunlight.','2025-01-13'),
      _r('r76_2','Ghazala Javed',5,'Stylish and well made. Great purchase!','2025-02-08'),
    ],
    'gen_77': [
      _r('r77_1','Nida Yasir',5,'Glasses are sturdy. Hinge is strong and smooth.','2025-01-19'),
      _r('r77_2','Fiza Ali',4,'Comfortable to wear for long hours. Good quality.','2025-02-14'),
    ],
    'gen_78': [
      _r('r78_1','Mehwish Hayat',5,'Belt quality is excellent. Looks genuine leather.','2025-01-25'),
      _r('r78_2','Humaima Malick',4,'Good belt. Buckle does not slip. Recommended.','2025-02-21'),
      _r('r78_3','Faryal Mehmood',5,'Gifted to my husband and he loves it daily!','2025-03-06'),
    ],
    'gen_79': [
      _r('r79_1','Nausheen Shah',4,'Nice cap. Brim keeps sun out of eyes well.','2025-01-30'),
      _r('r79_2','Zhalay Sarhadi',5,'Stylish cap. Fits comfortably on medium head size.','2025-02-27'),
    ],
    'gen_80': [
      _r('r80_1','Mariam Ansari',5,'Perfume smells divine. Very sophisticated scent.','2025-01-12'),
      _r('r80_2','Sarwat Gilani',4,'Good perfume. Lasts about 5 hours on clothes.','2025-02-07'),
    ],
    'gen_81': [
      _r('r81_1','Sumbul Iqbal',5,'Attar is very authentic. Pure oriental fragrance.','2025-01-17'),
      _r('r81_2','Komal Rizvi',4,'Nice attar. Small bottle but very concentrated.','2025-02-12'),
      _r('r81_3','Sanam Baloch',5,'Love this attar! Best traditional scent I found online.','2025-03-03'),
    ],
    'gen_82': [
      _r('r82_1','Zain ul Haq',4,'Body spray is fresh and long lasting. Pleasant scent.','2025-01-23'),
      _r('r82_2','Atif Hussain',5,'Great body spray for gym and outdoor use.','2025-02-19'),
    ],
    'gen_83': [
      _r('r83_1','Ahmed Bilal',5,'Polo fabric is soft and collar is clean.','2025-01-28'),
      _r('r83_2','Aoon Zafar',4,'Comfortable polo. Size is accurate as per chart.','2025-02-25'),
    ],
    'gen_84': [
      _r('r84_1','Bilal Saeed',5,'Tee is great for casual wear. Very lightweight.','2025-01-10'),
      _r('r84_2','Usman Khalid',4,'Nice tee. Print is well done and clear.','2025-02-05'),
      _r('r84_3','Hamza Yousuf',5,'Bought 4 tees and all are excellent quality!','2025-03-01'),
    ],
    'gen_85': [
      _r('r85_1','Talib Hussain',4,'Formal shirt is neat. Collar stays crisp all day.','2025-01-15'),
      _r('r85_2','Imran Ashraf',5,'Very smart formal shirt. Buttons are pearl-like.','2025-02-10'),
    ],
    'gen_86': [
      _r('r86_1','Adeel Akhtar',5,'Jeans quality is very impressive. Will not fade.','2025-01-20'),
      _r('r86_2','Sarmad Khoosat',4,'Good jeans. Slim cut but not too tight.','2025-02-15'),
    ],
    'gen_87': [
      _r('r87_1','Khalid Ahmed',5,'Chinos are well made and stylish. Love the colour.','2025-01-27'),
      _r('r87_2','Naveen Waqar',4,'Good chinos. Comfortable waistband and nice pockets.','2025-02-23'),
      _r('r87_3','Javed Sheikh',5,'Excellent value! Wearing these to office daily.','2025-03-05'),
    ],
    'gen_88': [
      _r('r88_1','Zahid Ahmed',4,'Shorts are comfortable and look good.','2025-01-12'),
      _r('r88_2','Rashid Nazir',5,'Perfect casual shorts. Cool in summer heat.','2025-02-07'),
    ],
    'gen_89': [
      _r('r89_1','Asad Ullah',5,'Jacket is amazing quality. Very warm for Islamabad winters.','2025-01-18'),
      _r('r89_2','Mubashar Khan',4,'Nice jacket. Zipper works smoothly. Inner lining is soft.','2025-02-13'),
    ],
    'gen_90': [
      _r('r90_1','Rizwan Ahmed',5,'Blazer looks sharp and classy. Exactly as shown.','2025-01-24'),
      _r('r90_2','Kashif Nisar',4,'Good blazer. Buttons are solid. Runs slightly large.','2025-02-20'),
      _r('r90_3','Abid Ali',5,'Wore this blazer to my engagement. Loved it!','2025-03-02'),
    ],
    'gen_91': [
      _r('r91_1','Waqas Ahmad',4,'Hoodie is warm and stylish. Good winter essential.','2025-01-29'),
      _r('r91_2','Nadeem Akbar',5,'Best hoodie this season. Very cozy!','2025-02-26'),
    ],
    'gen_92': [
      _r('r92_1','Saadat Khan',5,'Shawl is very comfortable. Pure soft fabric.','2025-01-11'),
      _r('r92_2','Riaz ul Haq',4,'Good quality shawl. Warm and lightweight.','2025-02-06'),
    ],
    'gen_93': [
      _r('r93_1','Farrukh Shehzad',5,'Sweater is excellent. Great winter purchase.','2025-01-17'),
      _r('r93_2','Hamid Khan',4,'Good sweater. Does not pill after washing.','2025-02-12'),
      _r('r93_3','Ghulam Abbas',5,'Warm and comfortable. My favourites winter sweater!','2025-03-04'),
    ],
    'gen_94': [
      _r('r94_1','Saeed Anwar',4,'Muffler is super soft against the skin.','2025-01-22'),
      _r('r94_2','Ramiz Raja',5,'Great muffler. Very warm and stylish!','2025-02-18'),
    ],
    'gen_95': [
      _r('r95_1','Shoaib Malik',5,'Kameez shalwar is beautifully made. Love it.','2025-01-28'),
      _r('r95_2','Sarfaraz Ahmed',4,'Good traditional dress. Fabric is smooth and cool.','2025-02-24'),
    ],
    'gen_96': [
      _r('r96_1','Zaheer Abbas',5,'Kurta trouser is elegant and comfortable.','2025-01-14'),
      _r('r96_2','Majid Khan',4,'Nice outfit. Embroidery is neat and fine.','2025-02-09'),
      _r('r96_3','Asif Iqbal',5,'Perfect for Eid celebrations. Got many compliments!','2025-03-01'),
    ],
    'gen_97': [
      _r('r97_1','Javed Miandad',4,'Good unstitched fabric. Texture feels premium.','2025-01-21'),
      _r('r97_2','Hanif Mohammad',5,'Excellent fabric quality. Tailor praised it too.','2025-02-17'),
    ],
    'gen_98': [
      _r('r98_1','Wasim Akram',5,'Formal shoes look really classy and feel comfortable.','2025-01-26'),
      _r('r98_2','Waqar Younis',4,'Good formal shoes. Sole is durable and non-slip.','2025-02-22'),
    ],
    'gen_99': [
      _r('r99_1','Mushtaq Ahmed',5,'Sneakers are trendy and very comfortable.','2025-01-09'),
      _r('r99_2','Saqlain Mushtaq',4,'Nice sneakers. Good grip and breathable material.','2025-02-04'),
      _r('r99_3','Danish Kaneria',5,'Looking great with my casual outfits!','2025-03-02'),
    ],
    'gen_100': [
      _r('r100_1','Umar Akmal',4,'Good belt quality. Holds well throughout the day.','2025-01-13'),
      _r('r100_2','Sohaib Maqsood',5,'Very sturdy belt. Buckle is premium and shiny.','2025-02-08'),
    ],
    'gen_101': [
      _r('r101_1','Asad Shafiq',5,'Cap is stylish and the embroidery is sharp.','2025-01-19'),
      _r('r101_2','Shan Masood',4,'Good cap. Fits my head well. Adjustable strap works.','2025-02-14'),
    ],
    'gen_102': [
      _r('r102_1','Haris Rauf',5,'Perfume is very rich and long lasting. Love it!','2025-01-25'),
      _r('r102_2','Naseem Shah',4,'Nice fragrance profile. Fresh and clean scent.','2025-02-21'),
      _r('r102_3','Mohammad Amir',5,'Best perfume from Rakhshwear. Will reorder!','2025-03-06'),
    ],
    'gen_103': [
      _r('r103_1','Shahnawaz Dahani',4,'Attar is authentic and smooth. A tiny drop lasts hours.','2025-01-30'),
      _r('r103_2','Zaman Khan',5,'Premium attar. Very traditional and royal scent.','2025-02-27'),
    ],
    'gen_104': [
      _r('r104_1','Agha Salman',5,'Body spray freshness lasts easily 4 to 5 hours.','2025-01-12'),
      _r('r104_2','Fawad Alam',4,'Good body spray. Light scent suitable for daily use.','2025-02-07'),
    ],
    'gen_105': [
      _r('r105_1','Taufeeq Umar',5,'Polo fabric is thick and durable. Very satisfied.','2025-01-18'),
      _r('r105_2','Kamran Younis',4,'Good polo. Colour is vibrant and true to picture.','2025-02-13'),
    ],
    'gen_106': [
      _r('r106_1','Abdur Razzaq',5,'Excellent tee. Soft fabric and clean print.','2025-01-23'),
      _r('r106_2','Yasir Hameed',4,'Good graphic tee. Does not wrinkle easily.','2025-02-19'),
      _r('r106_3','Salman Butt',5,'Bought 3 in different colours. All are awesome!','2025-03-05'),
    ],
    'gen_107': [
      _r('r107_1','Mohammad Sami',4,'Formal shirt is well stitched. Buttons are tight.','2025-01-28'),
      _r('r107_2','Shoaib Ahmed',5,'Very professional look. I wear this for meetings.','2025-02-25'),
    ],
    'gen_108': [
      _r('r108_1','Moin Khan',5,'Jeans are comfortable and look stylish. Great buy.','2025-01-10'),
      _r('r108_2','Rashid Latif',4,'Good denim. Does not bleed colour in wash.','2025-02-05'),
    ],
    'gen_109': [
      _r('r109_1','Aamir Sohail',5,'Chinos are smart. Easy to dress up or down.','2025-01-16'),
      _r('r109_2','Ramiz Md',4,'Good chinos. Pocket depth is good. Comfortable all day.','2025-02-11'),
      _r('r109_3','Ijaz Ahmed',5,'My casual everyday chinos. Very comfortable!','2025-03-03'),
    ],
    'gen_110': [
      _r('r110_1','Zahid Mahmood',4,'Good shorts. Elastic waist is comfortable.','2025-01-21'),
      _r('r110_2','Nadeem Ghauri',5,'Perfect summer shorts. Very light and airy material.','2025-02-16'),
    ],
    'gen_111': [
      _r('r111_1','Kabir Khan',5,'Jacket is heavy and warm. Great for Murree trips.','2025-01-27'),
      _r('r111_2','Amir Khan',4,'Nice jacket. Pockets are deep and zipper pulls smooth.','2025-02-23'),
    ],
    'gen_112': [
      _r('r112_1','Zain Malik',5,'Perfect polo shirt. My favourite in the collection.','2025-01-14'),
      _r('r112_2','Atif Javed',4,'Good quality. True to size.','2025-02-09'),
      _r('r112_3','Ahmed Khan',5,'Ordered twice already. Excellent quality!','2025-03-01'),
    ],
    'gen_113': [
      _r('r113_1','Aoon Baig',5,'Sweater is super cozy. Wearing it right now!','2025-01-20'),
      _r('r113_2','Bilal Ahmed',4,'Good sweater. Warm and comfortable for daily wear.','2025-02-15'),
    ],
    // gen_114 to gen_143 — intentionally no seed reviews (30 products)
  };
}
