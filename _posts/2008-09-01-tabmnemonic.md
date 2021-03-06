---
layout: post
category: swing
folder: TabMnemonic
title: JTabbedPaneのタブにMnemonicを追加
tags: [JTabbedPane, Mnemonic, JLabel]
author: aterai
pubdate: 2008-09-01T13:22:20+09:00
description: JTabbedPaneのタブにMnemonicを追加します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTUu2fjTpI/AAAAAAAAAmg/EST6gnFRH84/s800/TabMnemonic.png
comments: true
---
## 概要
`JTabbedPane`のタブに`Mnemonic`を追加します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTUu2fjTpI/AAAAAAAAAmg/EST6gnFRH84/s800/TabMnemonic.png %}

## サンプルコード
<pre class="prettyprint"><code>int tabIdx = 3;
tab.addTab("Button", new JButton("button"));
tab.setMnemonicAt(tabIdx, KeyEvent.VK_B);
tab.setDisplayedMnemonicIndexAt(tabIdx, 0);
</code></pre>

## 解説
上記のサンプルコードは、`JTabbedPane`の`3`番目のタブに`JTabbedPane#setMnemonicAt(3, KeyEvent.VK_B)`メソッドを使用して`Mnemonic`を設定し、<kbd>Alt+B</kbd>のキー入力でそのタブにフォーカス移動が可能になっています。

また、タブタイトルの先頭文字(`B`)にアンダーラインが入るように`JTabbedPane#setDisplayedMnemonicIndexAt(...)`メソッドで設定しています。

- - - -
- `JDK 6`以降でタブタイトルに`Component`を使用している場合、`JTabbedPane#setDisplayedMnemonicIndexAt(...)`メソッドでは`Mnemonic`にアンダーラインは表示されないので、以下のように追加するコンポーネント側でアンダーラインを表示するための設定が必要

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>int index = tab.getTabCount();
String tabTitle = "label(0)";
JPanel p = new JPanel(new BorderLayout());
JLabel label = new JLabel(tabTitle);
JButton button = new JButton("x");
p.add(label,  BorderLayout.WEST);
p.add(button, BorderLayout.EAST);
tab.addTab(tabTitle, new JTree());
tab.setTabComponentAt(index, p);
tab.setMnemonicAt(index, KeyEvent.VK_0);
label.setDisplayedMnemonic(KeyEvent.VK_0);
</code></pre>

## 参考リンク
- [JTabbedPane#setMnemonicAt(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTabbedPane.html#setMnemonicAt-int-int-)
- [JTabbedPane#setDisplayedMnemonicIndexAt(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTabbedPane.html#setDisplayedMnemonicIndexAt-int-int-)

<!-- dummy comment line for breaking list -->

## コメント
