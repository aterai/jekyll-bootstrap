---
layout: post
title: JTreeの水平垂直線を表示しない
category: swing
folder: TreePaintLines
tags: [JTree, UIManager]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-02-04

## JTreeの水平垂直線を表示しない
`JTree`のアイコンを繋ぐ水平垂直線の表示の有無を切り替えます。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTWNxTrfYI/AAAAAAAAAo4/xS9RjkcNYYM/s800/TreePaintLines.png %}

### サンプルコード
<pre class="prettyprint"><code>final JTree tree = new JTree();
add(new JCheckBox(new AbstractAction("Tree.paintLines") {
  @Override public void actionPerformed(ActionEvent e) {
    if(((JCheckBox)e.getSource()).isSelected()) {
      UIManager.put("Tree.paintLines", Boolean.TRUE);
    }else{
      UIManager.put("Tree.paintLines", Boolean.FALSE);
    }
    tree.updateUI(); // 左のJTreeだけ更新
    //SwingUtilities.updateComponentTreeUI(MainPanel.this);
  }
}), BorderLayout.NORTH);
</code></pre>

### 解説
上記のサンプルでは、左の`JTree`の水平線などの表示を、`UIManager.put("Tree.paintLines", Boolean.FALSE);`で切り替えています(右は常に非表示)。

元々、線を表示しない`GTKLookAndFeel`などでは、`UIManager.put("Tree.paintLines", Boolean.TRUE);`としても線は描画されないようです。

複数の`JTree`の表示を個別に切り替えたい場合は、[Hide horizontal and vertical lines in a JTree | Oracle Forums](https://forums.oracle.com/thread/1367209)で、Michael_Dunn さんが投稿(`2007/10/24 2:42`)したコードのように、`BasicTreeUI#paintHorizontalLine`メソッドなどをオーバーライドする方法もあります。

### 参考リンク
- [Hide horizontal and vertical lines in a JTree | Oracle Forums](https://forums.oracle.com/thread/1367209)

<!-- dummy comment line for breaking list -->

### コメント
