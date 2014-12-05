---
layout: post
category: swing
folder: ExpandablePanel
title: JPanelの展開と折り畳み
tags: [JPanel, BorderLayout]
author: aterai
pubdate: 2004-11-01T01:05:24+09:00
description: JPanelにBorderLayoutを設定し、JButtonのクリックで子コンポーネントの配置を入れ替えることで、それらの展開と折り畳みを行います。
comments: true
---
## 概要
`JPanel`に`BorderLayout`を設定し、`JButton`のクリックで子コンポーネントの配置を入れ替えることで、それらの展開と折り畳みを行います。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMQbS7ipI/AAAAAAAAAY4/xXDc9VVk87A/s800/ExpandablePanel.png %}

## サンプルコード
<pre class="prettyprint"><code>private void initComps(
    List&lt;? extends AbstractExpansionPanel&gt; list,
    JComponent source) {
  setVisible(false);
  centerBox.removeAll();
  northBox.removeAll();
  southBox.removeAll();
  boolean insertSouth = false;
  for (AbstractExpansionPanel exp : list) {
    if (source.equals(exp) &amp;&amp; exp.isSelected()) {
      centerBox.add(exp);
      insertSouth = true;
      continue;
    }
    exp.setSelected(false);
    if (insertSouth) {
      southBox.add(exp);
    } else {
      northBox.add(exp);
    }
  }
  setVisible(true);
}
</code></pre>

## 解説
上記のサンプルでは、ボタンが押されるたびにそのパネルの展開(子コンポーネントの追加)と折り畳み(子コンポーネントの削除)を行っています。同時に`BorderLayout`の`NORTH`、`CENTER`、`SOUTH`に各パネルを振り分けを行い、展開されるパネル一つだけが推奨サイズが無視されて任意の高さに拡張される`CENTER`に配置されます。

- - - -
[L2FProd.com - Common Components](http://common.l2fprod.com/) にある`JOutlookBar`で、アニメーション付きでパネルの展開や折り畳みが可能です。ソースも公開されているので参考にしてみてください。

## 参考リンク
- [JPanelをアコーディオン風に展開](http://ateraimemo.com/Swing/AccordionPanel.html)

<!-- dummy comment line for breaking list -->

## コメント
