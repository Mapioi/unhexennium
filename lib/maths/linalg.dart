import 'package:unhexennium/maths/rational.dart';

List<List<Rational>> create2dArray(int m, int n, {Rational filled}) {
  return new List(m)
      .map((_) => new List(n).map((_) => filled).toList())
      .toList();
}

class RationalMatrix {
  List<List<Rational>> items;
  int m, n;

  RationalMatrix(this.items) {
    m = items.length;
    n = m == 0 ? 0 : items[0].length;
  }

  RationalMatrix.identity(int size) {
    items = create2dArray(size, size, filled: new Rational.fromInt(0));
    for (int i = 0; i < size; ++i) {
      items[i][i] = new Rational.fromInt(1);
    }
    m = n = size;
  }

  RationalMatrix.empty(this.m, this.n) {
    items = create2dArray(m, n);
  }

  RationalMatrix get transpose {
    var transposeItems = create2dArray(n, m);
    for (int i = 0; i < m; ++i) {
      for (int j = 0; j < n; ++j) {
        transposeItems[j][i] = items[i][j];
      }
    }
    return new RationalMatrix(transposeItems);
  }

  void swapRowsAt(int r1, int r2) {
    for (int j = 0; j < n; ++j) {
      Rational temp = items[r1][j];
      items[r1][j] = items[r2][j];
      items[r2][j] = temp;
    }
  }

  void multiplyRowAtBy(int r, Rational k) {
    assert(k.numerator != 0);
    for (int j = 0; j < n; ++j) {
      items[r][j] *= k;
    }
  }

  void addRowAtByToRowAt(int row, Rational k, int targetRow) {
    assert(row != targetRow);
    for (int j = 0; j < n; ++j) {
      items[targetRow][j] += k * items[row][j];
    }
  }

  void toReducedRowEchelonForm({RationalMatrix juxtaposed}) {
    int i = 0;
    int j = 0;

    var pivotRowStack = <int>[];
    var pivotColStack = <int>[];

    // Forward elimination
    while (i < m && j < n) {
      Rational pivot = items[i][j];
      if (pivot.numerator == 0) {
        for (int i2 = i + 1; i2 < m; ++i2) {
          Rational candidatePivot = items[i2][j];
          if (candidatePivot.numerator != 0) {
            pivot = candidatePivot;
            swapRowsAt(i, i2);
            if (juxtaposed != null) juxtaposed.swapRowsAt(i, i2);
            break;
          }
        }
        if (pivot.numerator == 0) {
          ++j;
          continue;
        }
      }
      pivotRowStack.add(i);
      pivotColStack.add(j);
      multiplyRowAtBy(i, pivot.reciprocal);
      if (juxtaposed != null) juxtaposed.multiplyRowAtBy(i, pivot.reciprocal);
      for (int i2 = i + 1; i2 < m; ++i2) {
        Rational coefficient = items[i2][j].opposite;
        addRowAtByToRowAt(i, coefficient, i2);
        if (juxtaposed != null)
          juxtaposed.addRowAtByToRowAt(i, coefficient, i2);
      }
      ++i;
      ++j;
    }

    // Backward substitution
    while (pivotRowStack.length > 0) {
      i = pivotRowStack.removeLast();
      j = pivotColStack.removeLast();
      for (int i2 = 0; i2 < i; ++i2) {
        Rational coefficient = items[i2][j].opposite;
        addRowAtByToRowAt(i, coefficient, i2);
        if (juxtaposed != null)
          juxtaposed.addRowAtByToRowAt(i, coefficient, i2);
      }
    }
  }

  List<List<Rational>> get nullSpace {
    var aT = transpose;
    var iT = new RationalMatrix.identity(n);
    aT.toReducedRowEchelonForm(juxtaposed: iT);

    var kernel = <List<Rational>>[];
    for (int i = 0; i < n; ++i) {
      bool isNull = true;
      for (int j = 0; j < m; ++j) {
        if (aT.items[i][j].numerator != 0) isNull = false;
      }
      if (isNull) {
        kernel.add(iT.items[i]);
      }
    }
    return kernel;
  }
}
