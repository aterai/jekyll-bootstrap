---
layout: post
category: swing
folder: BigDecimalSpinnerModel
title: JSpinnerの上下限値をBigDecimalで比較する
tags: [JSpinner, BigDecimal, SpinnerNumberModel]
author: aterai
pubdate: 2014-01-20T02:06:20+09:00
description: JSpinnerで浮動小数点型のモデルを使用する場合、最大値と最小値の比較をBigDecimalで行うよう変更します。
image: https://lh6.googleusercontent.com/-JztoRl3kot0/UtvN48iHZ3I/AAAAAAAAB-g/D3QcAYgr_ks/s800/BigDecimalSpinnerModel.png
comments: true
---
## 概要
`JSpinner`で浮動小数点型のモデルを使用する場合、最大値と最小値の比較を`BigDecimal`で行うよう変更します。

{% download https://lh6.googleusercontent.com/-JztoRl3kot0/UtvN48iHZ3I/AAAAAAAAB-g/D3QcAYgr_ks/s800/BigDecimalSpinnerModel.png %}

## サンプルコード
<pre class="prettyprint"><code>class BigDecimalSpinnerModel extends SpinnerNumberModel {
  public BigDecimalSpinnerModel(
      double value, double minimum, double maximum, double stepSize) {
    super(value, minimum, maximum, stepSize);
  }

  @Override public Object getPreviousValue() {
    return incrValue(-1);
  }

  @Override public Object getNextValue() {
    return incrValue(+1);
  }

  private Number incrValue(int dir) {
    BigDecimal value    = BigDecimal.valueOf((Double) getNumber());
    BigDecimal stepSize = BigDecimal.valueOf((Double) getStepSize());
    BigDecimal newValue = dir &gt; 0 ? value.add(stepSize) : value.subtract(stepSize);

    BigDecimal maximum  = BigDecimal.valueOf((Double) getMaximum());
    if (maximum.compareTo(newValue) &lt; 0) {
      return null;
    }

    BigDecimal minimum  = BigDecimal.valueOf((Double) getMinimum());
    if (minimum.compareTo(newValue) &gt; 0) {
      return null;
    }
    return newValue;
  }
}
</code></pre>

## 解説
- 上: `SpinnerNumberModel`
    - `Double`型の`SpinnerNumberModel`では、最大・最小値の比較に、`Double#compare(...)`が使用されている
    - `stepSize`に指定した`0.1`などが持つ浮動小数点誤差のため、このサンプルの`JSpinner`の場合、下限(`2.0`や`29.6`)にダウンボタンで遷移できない
        - 例えば、`29.7 - 29.6 - 0.1 >= 0`は`false`なので、ダウンボタンで`29.7`から`29.6`に遷移不可
- 下: `BigDecimalSpinnerModel`
    - `SpinnerNumberModel#getPreviousValue()`などをオーバーライドして、`Double#compareTo(Double)`ではなく、`BigDecimal#compareTo(BigDecimal)`で最小値との比較を行う

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JavaFAQ: 浮動小数 float/double](http://raigar.main.jp/java/faq/S029.html)
- [java - JSpinner not showing minimum value on pressing down arrow - Stack Overflow](https://stackoverflow.com/questions/21158043/jspinner-not-showing-minimum-value-on-pressing-down-arrow)
- [SpinnerNumberModelに上限値を超える値を入力](https://ateraimemo.com/Swing/SpinnerNumberModel.html)

<!-- dummy comment line for breaking list -->

## コメント
