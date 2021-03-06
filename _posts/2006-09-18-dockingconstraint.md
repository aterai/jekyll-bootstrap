---
layout: post
category: swing
folder: DockingConstraint
title: JToolBarのドッキングを上下のみに制限
tags: [JToolBar, BorderLayout]
author: aterai
pubdate: 2006-09-18T18:01:15+09:00
description: JToolBarのドッキングを上下のみに制限して、左右を無視するように設定します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLq6lRV0I/AAAAAAAAAX8/dKnoZJh1xrM/s800/DockingConstraint.png
comments: true
---
## 概要
`JToolBar`のドッキングを上下のみに制限して、左右を無視するように設定します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLq6lRV0I/AAAAAAAAAX8/dKnoZJh1xrM/s800/DockingConstraint.png %}

## サンプルコード
<pre class="prettyprint"><code>toolbar.setUI(new BasicToolBarUI() {
  @Override public boolean canDock(Component c, Point p) {
    return super.canDock(c, p) ? isHorizontalDockingConstraint(c, p) : false;
  }
  private boolean isHorizontalDockingConstraint(Component c, Point p) {
    if (!c.contains(p)) return false;
    int iv = toolBar.getOrientation() == JToolBar.HORIZONTAL
               ? toolBar.getSize().height
               : toolBar.getSize().width;
    if (p.x &gt;= c.getWidth() - iv) {
      return false;
    } else if (p.x &lt; iv) {
      return false;
    } else {
      return true;
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JToolBar`は上下にのみドッキングできるようになっているため、`JComboBox`のような横長のコンポーネントを配置している場合でも`JToolBar`のレイアウトが崩れにくくなっています。

`ToolBarUI#canDock(Component, Point)`メソッドをオーバーライドして、左右の場合は`false`を返すようにしています。

ドッキングできるかどうかを判定している`BasicToolBarUI#getDockingConstraint`メソッドが`private`のため、サンプルコードでは、これをコピーしてすこしだけ条件を変更した`isHorizontalDockingConstraint`メソッドを作成しています。

- - - -
- `BorderLayout`の`WEST`と`EAST`に適当なダミーコンポーネント(例えばサイズ`0`の`Box`)を配置すると、`LookAndFeel`を変更しなくてもドッキングの制限が可能になる

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JPanel panel = new JPanel(new BorderLayout());
panel.add(toolbar, BorderLayout.NORTH);
panel.add(Box.createRigidArea(new Dimension()), BorderLayout.WEST);
panel.add(Box.createRigidArea(new Dimension()), BorderLayout.EAST);
</code></pre>

## 参考リンク
[BasicToolBarUI#canDock(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/BasicToolBarUI.html#canDock-java.awt.Component-java.awt.Point-)

## コメント
