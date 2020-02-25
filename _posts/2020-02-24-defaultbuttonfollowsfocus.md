---
layout: post
category: swing
folder: DefaultButtonFollowsFocus
title: DefaultButtonをフォーカスが存在するJButtonに設定する
tags: [JButton, Focus, JRootPane]
author: aterai
pubdate: 2020-02-24T18:13:51+09:00
description: DefaultButtonではないJButtonにフォーカスが存在する場合、そのJButtonがDefaultButtonとしてふるまうよう設定します。
image: https://drive.google.com/uc?id=1psyQVTV93zuNxaZxHISe8XkyPWTPAS7Z
comments: true
---
## 概要
`DefaultButton`ではない`JButton`にフォーカスが存在する場合、その`JButton`が`DefaultButton`としてふるまうよう設定します。

{% download https://drive.google.com/uc?id=1psyQVTV93zuNxaZxHISe8XkyPWTPAS7Z %}

## サンプルコード
<pre class="prettyprint"><code>String KEY = "Button.defaultButtonFollowsFocus";
Box box = Box.createHorizontalBox();
box.setBorder(BorderFactory.createTitledBorder(KEY));
JRadioButton r1 = new JRadioButton("TRUE");
JRadioButton r2 = new JRadioButton("FALSE");
if (UIManager.getBoolean(KEY)) {
  r1.setSelected(true);
} else {
  r2.setSelected(true);
}
ButtonGroup bg = new ButtonGroup();
ActionListener al = e -&gt; UIManager.put(KEY, r1.equals(e.getSource()));
Arrays.asList(r1, r2).forEach(r -&gt; {
  r.addActionListener(al);
  bg.add(r);
  box.add(r);
});
</code></pre>

## 解説
- `UIManager.put("Button.defaultButtonFollowsFocus", Boolean.TRUE)`
    - デフォルトボタンではない`JButton`にフォーカスがある場合、<kbd>Enter</kbd>キー入力でデフォルトボタンではなく現在フォーカスが存在する`JButton`がクリックされる
    - たとえば上記のサンプルでデフォルトボタンを`Button1`、現在のフォーカスを`Button2`に設定して<kbd>Enter</kbd>キーを入力すると`Button2`がクリックされて`Beep`音が鳴る
    - `WindowsLookAndFeel`のデフォルト
- `UIManager.put("Button.defaultButtonFollowsFocus", Boolean.FALSE)`
    - デフォルトボタンではない`JButton`にフォーカスが存在する場合でも、<kbd>Enter</kbd>キー入力で常にデフォルトボタンがクリックされる
    - たとえば上記のサンプルでデフォルトボタンを`Button1`、現在のフォーカスを`Button2`に設定して<kbd>Enter</kbd>キーを入力すると`Button1`がクリックされて`Beep`音は鳴らない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Enter Key and Button « Java Tips Weblog](https://tips4java.wordpress.com/2008/10/25/enter-key-and-button/)
- [DefaultButtonの設定](https://ateraimemo.com/Swing/DefaultButton.html)

<!-- dummy comment line for breaking list -->

## コメント
