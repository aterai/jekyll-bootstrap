---
layout: post
category: swing
folder: CalendarFieldStepSize
title: JSpinnerに設定したSpinnerDateModelの各日付フィールドに増減サイズを指定する
tags: [JSpinner, SpinnerDateModel, Calendar]
author: aterai
pubdate: 2017-02-27T15:54:24+09:00
description: JSpinnerにSpinnerDateModelを設定し、スピンボタンをクリックした際の増減サイズを各日付フィールドごとに指定します。
image: https://drive.google.com/uc?id=1TPoA7k0gp-SsdcPNfoTDKvN4bZikpOkgrA
comments: true
---
## 概要
`JSpinner`に`SpinnerDateModel`を設定し、スピンボタンをクリックした際の増減サイズを各日付フィールドごとに指定します。

{% download https://drive.google.com/uc?id=1TPoA7k0gp-SsdcPNfoTDKvN4bZikpOkgrA %}

## サンプルコード
<pre class="prettyprint"><code>HashMap&lt;Integer, Integer&gt; stepSizeMap = new HashMap&lt;&gt;();
stepSizeMap.put(Calendar.HOUR_OF_DAY, 1);
stepSizeMap.put(Calendar.MINUTE,      1);
stepSizeMap.put(Calendar.SECOND,      30);
stepSizeMap.put(Calendar.MILLISECOND, 500);
JSpinner spinner2 = new JSpinner(new SpinnerDateModel(d, null, null, Calendar.SECOND) {
  @Override public Object getPreviousValue() {
    Calendar cal = Calendar.getInstance();
    cal.setTime(getDate());
    int calendarField = getCalendarField();
    int stepSize = Optional.ofNullable(stepSizeMap.get(calendarField)).orElse(1);
    cal.add(calendarField, -stepSize);
    Date prev = cal.getTime();
    return prev;
  }

  @Override public Object getNextValue() {
    Calendar cal = Calendar.getInstance();
    cal.setTime(getDate());
    int calendarField = getCalendarField();
    int stepSize = Optional.ofNullable(stepSizeMap.get(calendarField)).orElse(1);
    cal.add(calendarField, stepSize);
    Date next = cal.getTime();
    return next;
  }
});
</code></pre>

## 解説
- `Calendar.MINUTE`や`Calendar.SECOND`などの各日付フィールドごとに増加、減少のステップサイズを指定した`HashMap`を作成
- `SpinnerDateModel#getNextValue()`と`SpinnerDateModel#getPreviousValue()`の内部で、この`HashMap`を参照して`JSpinner`のスピンボタンなどでの値変更に利用
    - 上記のサンプルでは、秒フィールドにカーソルがある場合は`30`秒、ミリ秒の場合は`500`ミリ秒、マッピングされていないフィールドの場合は`1`ずつ増減

<!-- dummy comment line for breaking list -->

## 参考リンク
- [SpinnerDateModel#getNextValue() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/SpinnerDateModel.html#getNextValue--)

<!-- dummy comment line for breaking list -->

## コメント
