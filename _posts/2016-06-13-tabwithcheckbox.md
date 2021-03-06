---
layout: post
category: swing
folder: TabWithCheckBox
title: JTabbedPaneのタブにJCheckBoxを追加
tags: [JTabbedPane, JCheckBox, JPanel, JLabel]
author: aterai
pubdate: 2016-06-13T01:27:42+09:00
description: JTabbedPaneのタブ内にクリック可能なJCheckBoxを追加します。
image: https://lh3.googleusercontent.com/-b5jcwNkPYZc/V12KPOBZsFI/AAAAAAAAObI/5fJ6EGqkXMg7fYFyLSDa_MwGJ3hXZGE-QCCo/s800/TabWithCheckBox.png
comments: true
---
## 概要
`JTabbedPane`のタブ内にクリック可能な`JCheckBox`を追加します。

{% download https://lh3.googleusercontent.com/-b5jcwNkPYZc/V12KPOBZsFI/AAAAAAAAObI/5fJ6EGqkXMg7fYFyLSDa_MwGJ3hXZGE-QCCo/s800/TabWithCheckBox.png %}

## サンプルコード
<pre class="prettyprint"><code>JTabbedPane tabs = new JTabbedPane() {
  @Override public void addTab(String title, Component content) {
    super.addTab(title, content);
    JCheckBox check = new JCheckBox();
    check.setOpaque(false);
    check.setFocusable(false);
    JPanel p = new JPanel(new FlowLayout(FlowLayout.LEADING, 0, 0));
    p.setOpaque(false);
    p.add(check, BorderLayout.WEST);
    p.add(new JLabel(title));
    setTabComponentAt(getTabCount() - 1, p);
  }
};
</code></pre>

## 解説
上記のサンプルでは、`JDK 6`で追加された`JTabbedPane`のタブにコンポーネントを配置する機能を使用して`JCheckBox`を各タブの内部に追加しています。

直接`JCheckBox`を`JTabbedPane#setTabComponentAt(...)`で追加するのではなく、タブタイトルを`JLabel`に分離し、チェックアイコンのみの`JCheckBox`と合わせて`JPanel`に配置して使用しています。このため、タブタイトル文字列をクリックしても`JCheckBox`のチェック状態は変化せず(この`JLabel`はクリックイベントを処理しない)、タブの切り替えが実行されます。

## 参考リンク
- [JTabbedPane#setTabComponentAt(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTabbedPane.html#setTabComponentAt-int-java.awt.Component-)

<!-- dummy comment line for breaking list -->

## コメント
