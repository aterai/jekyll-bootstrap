---
layout: post
category: swing
folder: TreePaintLines
title: JTreeの水平垂直線を表示しない
tags: [JTree, UIManager]
author: aterai
pubdate: 2008-02-04T16:09:01+09:00
description: JTreeのアイコンを繋ぐ水平垂直線の表示の有無を切り替えます。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTWNxTrfYI/AAAAAAAAAo4/xS9RjkcNYYM/s800/TreePaintLines.png
comments: true
---
## 概要
`JTree`のアイコンを繋ぐ水平垂直線の表示の有無を切り替えます。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTWNxTrfYI/AAAAAAAAAo4/xS9RjkcNYYM/s800/TreePaintLines.png %}

## サンプルコード
<pre class="prettyprint"><code>final JTree tree = new JTree();
add(new JCheckBox(new AbstractAction("Tree.paintLines") {
  @Override public void actionPerformed(ActionEvent e) {
    if (((JCheckBox) e.getSource()).isSelected()) {
      UIManager.put("Tree.paintLines", Boolean.TRUE);
    } else {
      UIManager.put("Tree.paintLines", Boolean.FALSE);
    }
    SwingUtilities.updateComponentTreeUI(tree); // 左のJTreeだけ更新
  }
}), BorderLayout.NORTH);
</code></pre>

## 解説
上記のサンプルでは、左の`JTree`の水平線などの表示を、`UIManager.put("Tree.paintLines", Boolean.FALSE);`で切り替えています。

- 右の`JTree`は常に水平垂直線を非表示に設定
- デフォルトで線を表示しない`GTKLookAndFeel`などでは`UIManager.put("Tree.paintLines", Boolean.TRUE);`としても線は描画されない
- 複数の`JTree`の表示を個別に切り替えたい場合は、[Hide horizontal and vertical lines in a JTree | Oracle Forums](https://community.oracle.com/thread/1367209)で、Michael_Dunn さんが投稿(`2007/10/24 2:42`)しているコードのように、`BasicTreeUI#paintHorizontalLine(...)`メソッドなどをオーバーライドする方法がある

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Hide horizontal and vertical lines in a JTree | Oracle Forums](https://community.oracle.com/thread/1367209)
- [JTreeのノード間の接続線のスタイルを変更する](https://ateraimemo.com/Swing/TreeLineStyle.html)

<!-- dummy comment line for breaking list -->

## コメント
