import 'package:trpc_client/src/parser.dart';
import 'package:trpc_client/src/utils.dart';
import 'package:trpc_client/trpc_client.dart';
import 'package:test/test.dart';

void main() {
  group('Query input serialization', () {
    test('JSON parsing', () {
      expect(serializeQueryInput({"testing": true, "userId": "userId"}),
          "%7B%22testing%22%3Atrue%2C%22userId%22%3A%22userId%22%7D");
    });

    test('String parsing', () {
      expect(serializeQueryInput("Testing"), "%22Testing%22");
    });
  });

  group('Batch Query input serialization', () {
    test('tRPC Example', () {
      expect(serializeQueryInputBatch(["1", "1"]),
          "%7B%220%22%3A%221%22%2C%221%22%3A%221%22%7D");
    });

    test('Complex parsing', () {
      expect(
          serializeQueryInputBatch([
            {"userId": 69, "page": 1, "offset": "alot"},
            {"userId": -1, "page": 999}
          ]),
          "%7B%220%22%3A%7B%22userId%22%3A69%2C%22page%22%3A1%2C%22offset%22%3A%22alot%22%7D%2C%221%22%3A%7B%22userId%22%3A-1%2C%22page%22%3A999%7D%7D");
    });
  });

  group('Error response parser', () {
    test('tRPC Example', () {
      identical(
        parseError({
          "error": {
            "json": {
              "message": "Something went wrong",
              "code": -32600, // JSON-RPC 2.0 code
              "data": {
                // Extra, customizable, meta data
                "code": "INTERNAL_SERVER_ERROR",
                "httpStatus": 500,
                "stack": "...",
                "path": "post.add"
              }
            }
          }
        }),
        TRPCError(
          message: "Something went wrong",
          errorCode: TRPCErrorCode.INTERNAL_SERVER_ERROR,
          stack: "...",
          path: "post.add",
        ),
      );
    });
  });

  group('Success response parser', () {
    test('tRPC Example', () {
      identical(
        parseSuccess({
          "result": {
            "data": {"id": "1", "title": "Hello tRPC", "body": "..."}
          }
        }),
        TRPCSuccessfulResponse(
            {"id": "1", "title": "Hello tRPC", "body": "..."}),
      );
    });
  });
}