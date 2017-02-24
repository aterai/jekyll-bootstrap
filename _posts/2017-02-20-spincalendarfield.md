---
layout: post
category: swing
folder: SpinCalendarField
title: JSpinnerのスピンで変更可能な日付フィールドを制限する
tags: [JSpinner, Calendar, Date, SpinnerDateModel]
author: aterai
pubdate: 2017-02-20T14:23:45+09:00
description: JSpinnerのスピンボタンで変更可能な日付フィールドを、カーソルで指定したフィールドではなく、初期値で指定したフィールドのみに制限します。
image: https://drive.google.com/uc?export=view&amp;id=1iKgUTqT5ugWKrxJ_KXkjbe-2rNjsGwujLw
comments: true
---
## 概要
`JSpinner`のスピンボタンで変更可能な日付フィールドを、カーソルで指定したフィールドではなく、初期値で指定したフィールドのみに制限します。

{% download https://drive.google.com/uc?export=view&amp;id=1iKgUTqT5ugWKrxJ_KXkjbe-2rNjsGwujLw %}

## サンプルコード
<pre class="prettyprint"><code>JSpinner spinner2 = new JSpinner(new SpinnerDateModel(d, null, null, Calendar.SECOND) {
  @Override public void setCalendarField(int calendarField) {
    // https://docs.oracle.com/javase/8/docs/api/javax/swing/SpinnerDateModel.html#setCalendarField-int-
    // If you only want one field to spin you can subclass and ignore the setCalendarField calls.
  }
});
((JSpinner.DefaultEditor) spinner2.getEditor()).getTextField().setFormatterFactory(factory);
</code></pre>

## 解説
- 上: `Default SpinnerDateModel`
    - スピンボタンをクリックすると、`Caret`が存在するフィールド値が増減する
- 下: `Override SpinnerDateModel#setCalendarField(...)`
    - スピンボタンをクリックすると、`Caret`が存在する位置には無関係に、初期値で指定した`Calendar.SECOND`のフィールド値が増減する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [SpinnerDateModel#setCalendarField(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/SpinnerDateModel.html#setCalendarField-int-)

<!-- dummy comment line for breaking list -->

## コメント
