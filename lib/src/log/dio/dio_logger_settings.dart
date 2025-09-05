import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class DioLoggerSettings extends TalkerDioLoggerSettings {
  const DioLoggerSettings({
    super.enabled = true,
    super.logLevel = LogLevel.debug,
    super.printResponseData = true,
    super.printResponseHeaders = false,
    super.printResponseMessage = true,
    super.printResponseRedirects = false,
    super.printResponseTime = false,
    super.printErrorData = true,
    super.printErrorHeaders = true,
    super.printErrorMessage = true,
    super.printRequestData = true,
    super.printRequestHeaders = false,
    super.printRequestExtra = false,
    super.hiddenHeaders = const <String>{},
    super.responseDataConverter,
    super.requestPen,
    super.responsePen,
    super.errorPen,
    super.requestFilter,
    super.responseFilter,
    super.errorFilter,
  });
}
