---
layout: post
title: JTabbedPaneのタブにMnemonicを追加
category: swing
folder: TabMnemonic
tags: [JTabbedPane, Mnemonic, JLabel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-09-01

## JTabbedPaneのタブにMnemonicを追加
`JTabbedPane`のタブに`Mnemonic`を追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTUu2fjTpI/AAAAAAAAAmg/EST6gnFRH84/s800/TabMnemonic.png)

### サンプルコード
<pre class="prettyprint"><code>tab.addTab("Button", new JButton("button"));
tab.setMnemonicAt(3, KeyEvent.VK_B);
tab.setDisplayedMnemonicIndexAt(3, 0);
</code></pre>

### 解説
上記のサンプルコードは、`3`番目のタブに<kbd>Alt+B</kbd>でフォーカスが移動するように、`JTabbedPane#setMnemonicAt`メソッドを使用しています。
また、タブタイトルの先頭文字(`B`)にアンダーラインが入るように`JTabbedPane#setDisplayedMnemonicIndexAt`メソッドで設定しています。

- - - -
`JDK 6`以降でタブに`JComponent`を追加する場合、`JTabbedPane#setDisplayedMnemonicIndexAt`メソッドでは`Mnemonic`にアンダーラインは引かれないので、追加したコンポーネント自体にアンダーラインを引くよう設定します。

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

### コメント
