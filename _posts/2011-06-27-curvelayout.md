---
layout: post
title: LayoutManagerを拡張して曲線上にコンポーネントを配置
category: swing
folder: CurveLayout
tags: [LayoutManager, FlowLayout, JPanel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-06-27

## LayoutManagerを拡張して曲線上にコンポーネントを配置
`LayoutManager`を拡張して曲線上にコンポーネントを配置します。

{% download https://lh4.googleusercontent.com/-Rww2mulIVEI/TggO-rFh_2I/AAAAAAAAA98/R3ZVsfyu3IU/s800/CurveLayout.png %}

### サンプルコード
<pre class="prettyprint"><code>final double A2 = 4.0;
panel2.setLayout(new FlowLayout() {
  @Override public void layoutContainer(Container target) {
    synchronized(target.getTreeLock()) {
      Insets insets = target.getInsets();
      int nmembers  = target.getComponentCount();
      if(nmembers&lt;=0) return;
      int vgap = getVgap();
      int hgap = getHgap();
      int rowh = (target.getHeight()-(insets.top+insets.bottom+vgap*2))/nmembers;
      int x = insets.left + hgap;
      int y = insets.top  + vgap;
      for(int i=0;i&lt;nmembers;i++) {
        Component m = target.getComponent(i);
        if(m.isVisible()) {
          Dimension d = m.getPreferredSize();
          m.setSize(d.width, d.height);
          m.setLocation(x, y);
          y += (vgap + Math.min(rowh, d.height));
          x = (int)(A2 * Math.sqrt(y));
        }
      }
    }
  }
});
</code></pre>

### 解説
- 左
    - `panel1 = new JPanel(new FlowLayout(FlowLayout.LEFT));`
- 右
    - `FlowLayout#layoutContainer(...)`をオーバーライドして、二次曲線の上にコンポーネントを並べる

<!-- dummy comment line for breaking list -->

### コメント
