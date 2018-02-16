---
layout: post
category: swing
folder: TabbedPaneInputVerifier
title: JTabbedPaneのタブ移動時にInputVerifierによる検証を実行する
tags: [JTabbedPane, InputVerifier, Focus]
author: aterai
pubdate: 2016-12-26T16:12:59+09:00
description: JTabbedPaneのタブ移動時にタブコンポーネントに設定されたInputVerifierを実行し、その検証で入力が無効な場合はタブの切替をキャンセルします。
image: https://drive.google.com/uc?id=1E4H4aD4uZ-DBc_H6-KLuEEsZoyJqNxdHuQ
comments: true
---
## 概要
`JTabbedPane`のタブ移動時にタブコンポーネントに設定された`InputVerifier`を実行し、その検証で入力が無効な場合はタブの切替をキャンセルします。

{% download https://drive.google.com/uc?id=1E4H4aD4uZ-DBc_H6-KLuEEsZoyJqNxdHuQ %}

## サンプルコード
<pre class="prettyprint"><code>tabbedPane.setModel(new DefaultSingleSelectionModel() {
  @Override public void setSelectedIndex(int index) {
    InputVerifier verifier = p.getInputVerifier();
    if (Objects.nonNull(verifier) &amp;&amp; !verifier.shouldYieldFocus(p)) {
      UIManager.getLookAndFeel().provideErrorFeedback(p);
      JOptionPane.showMessageDialog(p, "InputVerifier#verify(...): false");
      return;
    }
    super.setSelectedIndex(index);
  }
});
</code></pre>

## 解説
- デフォルト
    - タブ切替時に`JTextField`にフォーカスが存在する場合はその`InputVerifier`で検証が実行されるが、入力が無効の場合でもタブの移動は実行される
    - [Bug ID: JDK-4403182 InputVerifier failed on JTabbedPane & JMenuBar](https://bugs.openjdk.java.net/browse/JDK-4403182)
- `override SingleSelectionModel#setSelectedIndex(int): true`
    - `DefaultSingleSelectionModel#setSelectedIndex(int)`をオーバーライドした`SingleSelectionModel`を`JTabbedPane`に設定
    - 現在表示中のタブの`InputVerifier#shouldYieldFocus(...)`を実行し、入力が無効の場合はタブ切り替えの実行をキャンセルする
    - [Java Swing JTextField setInputVerifier keep focus on TextField - Stack Overflow](https://stackoverflow.com/questions/34315657/java-swing-jtextfield-setinputverifier-keep-focus-on-textfield)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Bug ID: JDK-4403182 InputVerifier failed on JTabbedPane & JMenuBar](https://bugs.openjdk.java.net/browse/JDK-4403182)
- [Java Swing JTextField setInputVerifier keep focus on TextField - Stack Overflow](https://stackoverflow.com/questions/34315657/java-swing-jtextfield-setinputverifier-keep-focus-on-textfield)

<!-- dummy comment line for breaking list -->

## コメント
