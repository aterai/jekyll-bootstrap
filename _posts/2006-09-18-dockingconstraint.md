---
layout: post
title: JToolBarのドッキングを上下のみに制限
category: swing
folder: DockingConstraint
tags: [JToolBar, BorderLayout]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-09-18

## JToolBarのドッキングを上下のみに制限
`JToolBar`のドッキングを上下のみに制限して、左右を無視するように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTLq6lRV0I/AAAAAAAAAX8/dKnoZJh1xrM/s800/DockingConstraint.png)

### サンプルコード
<pre class="prettyprint"><code>toolbar.setUI(new BasicToolBarUI() {
  public boolean canDock(Component c, Point p) {
    return super.canDock(c, p) ? isHorizontalDockingConstraint(c, p) : false;
  }
  private boolean isHorizontalDockingConstraint(Component c, Point p) {
    if (!c.contains(p)) return false;
    int iv = (toolBar.getOrientation() == JToolBar.HORIZONTAL)
                  ? toolBar.getSize().height
                  : toolBar.getSize().width;
    if (p.x &gt;= c.getWidth() - iv) {
      return false;
    }else if (p.x &lt; iv) {
      return false;
    }else{
      return true;
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、`JToolBar`は上下のみドッキングできるようになっているため、`JComboBox`のような横長のコンポーネントを配置している場合でもレイアウトが崩れにくくなっています。

`ToolBarUI#canDock(Component, Point)`メソッドをオーバーライドして、左右の場合は`false`を返すようにしています。

ドッキングできるかどうかを判定している`BasicToolBarUIのgetDockingConstraint`メソッドが`private`のため、サンプルコードでは、これコピーしてすこしだけ条件を変更した`isHorizontalDockingConstraint`メソッドを作成しています。

- - - -
`BorderLayout`の`WEST`と`EAST`に、適当にダミーコンポーネントを配置するだけでも、同様にドッキングをブロック出来るようです。

<pre class="prettyprint"><code>add(toolbar, BorderLayout.NORTH);
add(new JLabel(), BorderLayout.WEST);
add(new JLabel(), BorderLayout.EAST);
</code></pre>

### コメント