---
layout: post
title: JTreeで目次を作成する
category: swing
folder: TableOfContentsTree
tags: [JTree, DefaultTreeCellRenderer, BasicStroke]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-12-30

## JTreeで目次を作成する
`JTree`のノードにリーダーとページ番号を追加表示して目次を作成します。


{% download https://lh4.googleusercontent.com/-uecZSLw75K4/UsAxPx9ol2I/AAAAAAAAB9M/TcD_QI2Ex_Y/s800/TableOfContentsTree.png %}

### サンプルコード
<pre class="prettyprint"><code>class TableOfContentsTreeCellRenderer extends DefaultTreeCellRenderer {
  private static BasicStroke READER = new BasicStroke(
      1f, BasicStroke.CAP_BUTT, BasicStroke.JOIN_MITER,
      1f, new float[] { 1f }, 0f);
  private String pn;
  private Point pnPt = new Point();
  private int rxs, rxe, ry;
  private boolean isSynth = false;
  private final JPanel p = new JPanel(new BorderLayout()) {
    @Override public void paintComponent(Graphics g) {
      super.paintComponent(g);
      if(pn!=null) {
        Graphics2D g2 = (Graphics2D)g.create();
        g2.setColor(isSynth?getForeground():getTextNonSelectionColor());
        g2.drawString(pn, pnPt.x - getX(), pnPt.y);
        g2.setStroke(READER);
        g2.drawLine(rxs, pnPt.y, rxe - getX(), pnPt.y);
        g2.dispose();
      }
    }
    @Override public Dimension getPreferredSize() {
      Dimension d = super.getPreferredSize();
      d.width = Short.MAX_VALUE;
      return d;
    }
  };
  public TableOfContentsTreeCellRenderer() {
    super();
    p.setOpaque(false);
  }
  @Override public void updateUI() {
    super.updateUI();
    isSynth = getUI().getClass().getName().contains("Synth");
    if(isSynth) {
      //System.out.println("XXX: FocusBorder bug?, JDK 1.7.0, Nimbus start LnF");
      setBackgroundSelectionColor(new Color(0, true));
    }
  }
  @Override public Component getTreeCellRendererComponent(
      JTree tree, Object value, boolean selected, boolean expanded,
      boolean leaf, int row, boolean hasFocus) {
    JLabel l = (JLabel)super.getTreeCellRendererComponent(
        tree, value, selected, expanded, leaf, row, hasFocus);
    if(value instanceof DefaultMutableTreeNode) {
      DefaultMutableTreeNode n = (DefaultMutableTreeNode)value;
      Object o = n.getUserObject();
      if(o instanceof TableOfContents) {
        TableOfContents toc = (TableOfContents)o;
        FontMetrics metrics = l.getFontMetrics(l.getFont());
        int gap = l.getIconTextGap();
        int h = l.getPreferredSize().height;
        Insets ins = tree.getInsets();

        p.removeAll();
        p.add(l, BorderLayout.WEST);
        if(isSynth) p.setForeground(l.getForeground());

        pn = String.format("%3d", toc.page);
        pnPt.x = tree.getWidth() - metrics.stringWidth(pn) - gap;
        pnPt.y = (h + metrics.getAscent()) / 2;

        rxs = l.getPreferredSize().width + gap;
        rxe = tree.getWidth() - ins.right - metrics.stringWidth("000") - gap;
        ry  = h / 2;

        return p;
      }
    }
    pn = null;
    return l;
  }
}
</code></pre>

### 解説
- 左: `TreeCellRenderer`
    - `DefaultTreeCellRenderer`をオーバーライドし、デフォルトのレンダリングで使用する`JLabel`を`JTree`を超える十分な幅をもつ`JPanel`でラップ
        - `JTree#getScrollableTracksViewportWidth()`が常に`true`を返すようオーバーライドして、スクロールバーが表示されないよう設定(参考: [JTree cell width question | Oracle Forums](https://community.oracle.com/thread/1357473))
        - `JTree`のノードの幅には、最初に表示された時にキャッシュされたものが使用されるため、`JTable`や`JList`のレンダラーのように`LayoutManager`を使ったセル内でのレイアウトが使用できない(`JTree`をリサイズした場合、右寄せが維持できない)
        - 代わりに、ラップした`JPanel`の`paintComponent(...)`メソッドをオーバーライドして、ノードに続けてリーダー、`JTree`の右端付近にページ番号を表示
    - ページ番号などをクリックしてノードを展開可能
    - `JTree`に十分な幅がなく、ノードとページ番号が重なる場合などは考慮していない
- 右: `JTree#paintComponent(...)`
    - `JTree#paintComponent(...)`をオーバーライドし、ノードとは別にリーダーとページ番号を直接`JTree`上に描画
    - `JTree#getRowBounds(int)`で取得したノードのセル領域が表示中の場合だけ処理を行う
    - ページ番号などをクリックしてもノードを展開しない
    - `JTree`に十分なサイズがなく、ノードとページ番号が重なる場合などは考慮していない

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JTree tree2 = new JTree(makeModel()) {
  @Override public void updateUI() {
    super.updateUI();
    setBorder(BorderFactory.createTitledBorder("JTree#paintComponent(...)"));
    isSynth = getUI().getClass().getName().contains("Synth");
  }
  private boolean isSynth = false;
  private final BasicStroke reader = new BasicStroke(
      1f, BasicStroke.CAP_BUTT, BasicStroke.JOIN_MITER,
      1f, new float[] { 1f }, 0f);
  private Rectangle getVisibleRowsRect() {
    Insets i = getInsets();
    Rectangle visRect = getVisibleRect();
    if(visRect.x == 0 &amp;&amp; visRect.y == 0 &amp;&amp; visRect.width == 0 &amp;&amp;
       visRect.height == 0 &amp;&amp; getVisibleRowCount() &gt; 0) {
      // The tree doesn't have a valid bounds yet. Calculate
      // based on visible row count.
      visRect.width = 1;
      visRect.height = getRowHeight() * getVisibleRowCount();
    }else{
      visRect.x -= i.left;
      visRect.y -= i.top;
    }
    // we should consider a non-visible area above
    Component component = SwingUtilities.getUnwrappedParent(this);
    if(component instanceof JViewport) {
      component = component.getParent();
      if(component instanceof JScrollPane) {
        JScrollPane pane = (JScrollPane) component;
        JScrollBar bar = pane.getHorizontalScrollBar();
        if(bar != null &amp;&amp; bar.isVisible()) {
          int height = bar.getHeight();
          visRect.y -= height;
          visRect.height += height;
        }
      }
    }
    return visRect;
  }
  @Override public void paintComponent(Graphics g) {
    g.setColor(getBackground());
    g.fillRect(0,0,getWidth(),getHeight());
    super.paintComponent(g);
    Graphics2D g2 = (Graphics2D)g.create();
    FontMetrics fm = g.getFontMetrics();
    int pnmaxWidth = fm.stringWidth("000");
    Insets ins   = getInsets();
    Rectangle rect = getVisibleRowsRect();
    for(int i=0;i&lt;getRowCount();i++) {
      Rectangle r = getRowBounds(i);
      if(rect.intersects(r)) {
        TreePath path = getPathForRow(i);
        if(isSynth &amp;&amp; isRowSelected(i)) {
          TreeCellRenderer tcr = getCellRenderer();
          if(tcr instanceof DefaultTreeCellRenderer) {
            DefaultTreeCellRenderer renderer = (DefaultTreeCellRenderer)tcr;
            g2.setColor(renderer.getTextSelectionColor());
          }
        }else{
          g2.setColor(getForeground());
        }
        DefaultMutableTreeNode node =
          (DefaultMutableTreeNode)path.getLastPathComponent();
        Object o = node.getUserObject();
        if(o instanceof TableOfContents) {
          TableOfContents toc = (TableOfContents)o;
          String pn = "" + toc.page;
          int x = getWidth() -1 - fm.stringWidth(pn) - ins.right;
          int y = r.y + (r.height + fm.getAscent()) / 2;
          g2.drawString(pn, x, y);

          int gap = 5;
          int x2  = getWidth() -1 - pnmaxWidth - ins.right;
          Stroke s = g2.getStroke();
          g2.setStroke(reader);
          g2.drawLine(r.x + r.width + gap, y, x2 - gap, y);
          g2.setStroke(s);
        }
      }
    }
    g2.dispose();
  }
};
</code></pre>

- - - -
`NimbusLookAndFeel`等の場合、ノード選択時にリーダーとページ番号の文字色を変更するよう設定しています。

### 参考リンク
- [JTree cell width question | Oracle Forums](https://community.oracle.com/thread/1357473)

<!-- dummy comment line for breaking list -->

### コメント
