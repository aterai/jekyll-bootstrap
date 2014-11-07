---
layout: post
category: swing
folder: InternalFrameDropTarget
title: JInternalFrame間でのドラッグ＆ドロップによるJTableの行入れ替え
tags: [JInternalFrame, JDesktopPane, JTable, DragAndDrop]
author: aterai
pubdate: 2014-05-19T00:37:47+09:00
description: JInternalFrame間でJTableの行をドラッグ＆ドロップを使って入れ替えます。
comments: true
---
## 概要
`JInternalFrame`間で`JTable`の行をドラッグ＆ドロップを使って入れ替えます。

{% download https://lh5.googleusercontent.com/-UP_I_iTgtpc/U3jPL_jhwuI/AAAAAAAACFg/olJ1Sf-P_lU/s800/InternalFrameDropTarget.png %}

## サンプルコード
<pre class="prettyprint"><code>private boolean isDropableTableIntersection(TransferSupport info) {
  Component c = info.getComponent();
  if (!(c instanceof JTable)) {
    return false;
  }
  JTable target = (JTable) c;
  if (!target.equals(source)) {
    JDesktopPane dp = null;
    Container cn = SwingUtilities.getAncestorOfClass(JDesktopPane.class, target);
    if (cn instanceof  JDesktopPane) {
      dp = (JDesktopPane) cn;
    }

    JInternalFrame sf = getInternalFrame(source);
    JInternalFrame tf = getInternalFrame(target);
    if (sf == null || tf == null || dp.getIndexOf(tf) &lt; dp.getIndexOf(sf)) {
      return false;
    }

    Point pt = SwingUtilities.convertPoint(
        target, info.getDropLocation().getDropPoint(), dp);
    Rectangle rect = sf.getBounds().intersection(tf.getBounds());
    if (rect.contains(pt)) {
      return false;
    }
    //tf.moveToFront();
    //tf.getParent().repaint();
  }
  return true;
}
</code></pre>

## 解説
上記のサンプルでは、異なる`JInternalFrame`に配置した`JTable`の行をドラッグ＆ドロップで入れ替えています。使用する`TransferHandler`は[JTableの行を別のJTableにドラッグして移動](http://ateraimemo.com/Swing/DragRowsAnotherTable.html)のものとほぼ同じですが、前面の`JInternalFrame`内にある`JTable`からドラッグした場合、その`JTableHeader`や`JInternalFrame`のタイトルバー上でも、背面にある`JInternalFrame`に反応してドロップ可能になってしまうため、`TransferHandler#canImport(...)`をオーバーライドして、ドラッグ元とドロップ先の`JInternalFrame`の共通部分では背面にドロップ出来ないように変更しています。

## 参考リンク
- [JTableの行を別のJTableにドラッグして移動](http://ateraimemo.com/Swing/DragRowsAnotherTable.html)

<!-- dummy comment line for breaking list -->

## コメント
