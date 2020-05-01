---
layout: post
category: swing
folder: MenuArrowIcon
title: JMenuのArrowIconを変更する
tags: [JMenu, Icon, LookAndFeel]
author: aterai
pubdate: 2018-05-07T15:33:15+09:00
description: JMenuの右端に表示されるArrowIconの形状や選択色などを変更します。
image: https://drive.google.com/uc?id=1hLKnZ5Zcz3tP7v6YtwXYj0Gd8CKvno8r6w
comments: true
---
## 概要
`JMenu`の右端に表示される`ArrowIcon`の形状や選択色などを変更します。

{% download https://drive.google.com/uc?id=1hLKnZ5Zcz3tP7v6YtwXYj0Gd8CKvno8r6w %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("Menu.arrowIcon", new ArrowIcon());
// or: UIManager.getLookAndFeelDefaults().put("Menu.arrowIcon", new ArrowIcon());
// ...
class ArrowIcon implements Icon {
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D) g.create();

    if (c instanceof AbstractButton &amp;&amp; ((AbstractButton) c).getModel().isSelected()) {
      g2.setPaint(Color.WHITE);
    } else {
      g2.setPaint(Color.GRAY);
    }

    int w = getIconWidth() / 2;
    Path2D p = new Path2D.Double();
    p.moveTo(0, 0);
    p.lineTo(w, w);
    p.lineTo(0, getIconHeight());
    p.closePath();

    g2.translate(x, y);
    g2.fill(p);
    g2.dispose();
  }

  @Override public int getIconWidth() {
    return 8;
  }

  @Override public int getIconHeight() {
    return 8;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`UIManager.put("Menu.arrowIcon", new Icon() {...})`を使用して`JMenu`が使用する`ArrowIcon`を変更しています。

- `Icon#paintIcon(...)`メソッドをオーバーライドし、`JMenu`が選択されている場合は色を変更
    
    <pre class="prettyprint"><code>if (c instanceof AbstractButton &amp;&amp; ((AbstractButton) c).getModel().isSelected()) {
      g2.setPaint(Color.WHITE);
    } else {
      g2.setPaint(Color.GRAY);
    }
</code></pre>
- `WindowsLookAndFeel`で`JMenu`が選択されてサブメニューが表示されたときに`ArrowIcon`と重ならないようにアイコンの右側に余白を設定
- `NimbusLookAndFeel`では`UIManager.put("Menu.arrowIcon", new Icon() {...})`は無効、かつ`JMenuBar`に追加されている`JMenu`に`Menu.arrowIcon`が不正に表示されてしまう？
- 以下のように`UIManager.getLookAndFeelDefaults()`でアイコンを設定すると`NimbusLookAndFeel`でも有効だが、`JMenuBar`に追加されている`JMenu`に`Menu.arrowIcon`が不正に表示されてしまう現象は同じ
    
    <pre class="prettyprint"><code>UIManager.getLookAndFeelDefaults().put("Menu.arrowIcon", new ArrowIcon());

</code></pre>
- `NimbusLookAndFeel`などの場合、個別に`JMenu#putClientProperty("Nimbus.Overrides", ...)`でアイコンを変更することで回避可能
- 親が`JMenuBar`のコンポーネントにアイコンが設定されている場合は非表示にすることで回避可能
    
    <pre class="prettyprint"><code>class ArrowIcon implements Icon {
      @Override public void paintIcon(Component c, Graphics g, int x, int y) {
        Container parent = SwingUtilities.getUnwrappedParent(c);
        if (parent instanceof JMenuBar) {
          return;
        }
        Graphics2D g2 = (Graphics2D) g.create();
        // ...
</code></pre>
- * 参考リンク [#reference]
- [BasicMenuItemUI#arrowIcon (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/basic/BasicMenuItemUI.html#arrowIcon)

<!-- dummy comment line for breaking list -->

## コメント
