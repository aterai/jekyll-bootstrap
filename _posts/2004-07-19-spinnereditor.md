---
layout: post
title: JSpinnerを直接入力不可にする
category: swing
folder: SpinnerEditor
tags: [JSpinner]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-07-19

## JSpinnerを直接入力不可にする
`JSpinner`のエディタを編集不可にして、ボタンでしか値を変更できないようにします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTTojxcMLI/AAAAAAAAAkw/BznS8i5Xfp4/s800/SpinnerEditor.png %}

### サンプルコード
<pre class="prettyprint"><code>SpinnerNumberModel model = new SpinnerNumberModel(10, 0, 1000, 1);
JSpinner spinner = new JSpinner(model);
//UIManager.put("FormattedTextField.inactiveBackground", Color.RED);
JTextField field = ((JSpinner.NumberEditor)spinner.getEditor()).getTextField();
field.setEditable(false);
field.setBackground(UIManager.getColor("FormattedTextField.background"));
</code></pre>

### 解説
上記のサンプルでは、「直接編集不可」の場合、上下ボタンで値を変更することはできますが、直接キーボードから値を入力することができなくなります。

`JSpinner`の編集可・不可を変更するのではなく、`JSpinner`で使用するエディタから取得した`JTextField`の編集可・不可を切り替えています。

### コメント
