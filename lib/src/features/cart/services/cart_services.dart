import 'package:alhomaidhi_customer_app/src/features/cart/models/my_cart_response_model.dart';
import 'package:alhomaidhi_customer_app/src/utils/config/dio/dio_client.dart';
import 'package:alhomaidhi_customer_app/src/utils/constants/endpoints.dart';
import 'package:alhomaidhi_customer_app/src/utils/exceptions/homaidhi_exception.dart';
import 'package:alhomaidhi_customer_app/src/utils/helpers/auth_helper.dart';
import 'package:dio/dio.dart';

Future<MyCartResponseModel> getCart() async {
  try {
    final authDetails = await AuthHelper.getAuthDetails();
    final jsonResponse = await dioClient.get(
      APIEndpoints.getCart,
      options: Options(
        headers: {
          "Authorization": authDetails.token,
          "user_id": authDetails.userId,
        },
      ),
    );
    final response = MyCartResponseModel.fromJson(jsonResponse.data);
    if (response.status != "APP00") {
      throw HomaidhiException(
          status: response.status!, message: response.errorMessage!);
    } else {
      return response;
    }
  } catch (err) {
    if (err is HomaidhiException) {
      if (err.status != "APP003") {
        logger.e("Error from my cart services. ${err.message}");
      }
      throw HomaidhiException(
        status: err.status,
        message: err.message,
      );
    } else {
      throw Exception(err);
    }
  }
}