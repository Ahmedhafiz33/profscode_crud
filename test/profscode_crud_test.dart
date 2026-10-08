import 'package:profscode_crud/profscode_crud.dart';
import 'package:test/test.dart';

void main() {
  group('Crud', () {
    test('jsonDecodeSafe decodes JSON', () {
      final crud = Crud();

      expect(crud.jsonDecodeSafe('{"ok":true}'), {'ok': true});

      crud.close();
    });

    test('jsonDecodeSafe returns plain text for invalid JSON', () {
      final crud = Crud();

      expect(crud.jsonDecodeSafe('server error'), 'server error');
      expect(crud.jsonDecodeSafe('   '), isNull);

      crud.close();
    });
  });
}
