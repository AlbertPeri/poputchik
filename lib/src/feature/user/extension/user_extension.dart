import 'package:companion/src/config/app_config.dart';
import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/user/model/review/review.dart';
import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:companion_api/companion.dart';

extension UserX on User {
  UserDB toDb() => UserDB(
        /// в базе всегда только один пользоваиель
        userId: 1,
        id: id,
        name: name,
        surname: surname,
        patronymic: patronymic,
        phoneNumber: phoneNumber,
        hidePhone: hidePhone,
        reviewReceiver: reviewReceiver.toString(),
      );

  // UserResponse toUserResponse() => UserResponse(
  //       mainImage: mainImage,
  //       id: id,
  //       name: name,
  //       surname: surname,
  //       patronymic: patronymic,
  //       phoneNumber: phoneNumber,
  //       averageRating: averageRating,
  //       reviewReceiver:
  //           reviewReceiver.map((e) => e.toReviewResponse()).toList(),
  //     );

  UserForEditResponse toUserForEditResponse() => UserForEditResponse(
        usersId: id.toString(),
        name: name,
        surname: surname,
        patronymic: patronymic,
        phoneNumber: phoneNumber,
        hidePhone: hidePhone,
      );
}

extension ReviewResponseX on ReviewResponse {
  Review toReview() => Review(
        id: id,
        content: content,
        rating: rating,
        createdAt: createdAt,
        senderName: senderName,
        senderSurname: senderSurname,
        senderPatronymic: senderPatronymic,
      );
}

extension ReviewX on Review {
  ReviewResponse toReviewResponse() => ReviewResponse(
        id: id,
        content: content,
        rating: rating,
        createdAt: createdAt,
        senderName: senderName,
        senderSurname: senderSurname,
        senderPatronymic: senderPatronymic,
      );
}

extension UserResponseX on UserResponse {
  User toUser() => User(
        id: id,
        name: name,
        image: mainImage != null ? AppConfig.baseUrl + mainImage! : null,
        surname: surname,
        patronymic: patronymic,
        hidePhone: hidePhone,
        phoneNumber: phoneNumber,
        averageRating: averageRating?.toDouble() ?? 0.0,
        reviewReceiver:
            myReviews.map((response) => response.toReview()).toList(),
      );

  UserDB toDBUser() => UserDB(
        userId: 1,
        id: id,
        name: name,
        surname: surname,
        patronymic: patronymic,
        phoneNumber: phoneNumber,
        averageRating: averageRating?.toDouble() ?? 0.0,
        imageUrl: mainImage,
        hidePhone: hidePhone,
      );
}

extension UserDBX on UserDB {
  User toUser() => User(
        image: imageUrl,
        id: id,
        name: name ?? '',
        surname: surname ?? '',
        patronymic: patronymic ?? '',
        phoneNumber: phoneNumber ?? '',
        averageRating: averageRating,
        reviewReceiver: [],
        hidePhone: hidePhone,
      );
}
