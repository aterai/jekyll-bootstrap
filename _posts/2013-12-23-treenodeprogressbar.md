---
layout: post
title: JTreeのノードにJProgressBarを表示する
category: swing
folder: TreeNodeProgressBar
tags: [JTree, JProgressBar, DefaultTreeCellRenderer, SwingWorker, ExecutorService]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-12-23

## JTreeのノードにJProgressBarを表示する
`JTree`のノードに`JProgressBar`を表示する`TreeCellRenderer`を設定します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/-SBg5NOTGinM/UrcLHfPzXVI/AAAAAAAAB84/HD0k-sWiJGo/s800/TreeNodeProgressBar.png)

### サンプルコード
<pre class="prettyprint"><code>class ProgressBarRenderer extends DefaultTreeCellRenderer {
  private int nodeWidth = 100;
  private static int barHeight = 4;
  private final JProgressBar b = new JProgressBar(0, 100) {
    @Override public Dimension getPreferredSize() {
      Dimension d = super.getPreferredSize();
      d.height = barHeight;
      d.width  = nodeWidth;
      return d;
    }
    @Override public void updateUI() {
      super.updateUI();
      setUI(new BasicProgressBarUI());
    }
  };
  private final JPanel p = new JPanel(new BorderLayout());
  public ProgressBarRenderer() {
    super();
    b.setOpaque(false);
    p.setOpaque(false);
    b.setStringPainted(true);
    b.setString("");
    b.setBorder(BorderFactory.createEmptyBorder(0, 0, 0, 0));
  }
  @Override public Component getTreeCellRendererComponent(
      JTree tree, Object value, boolean selected, boolean expanded,
      boolean leaf, int row, boolean hasFocus) {
    Object o = ((DefaultMutableTreeNode)value).getUserObject();
    JComponent c = (JComponent)super.getTreeCellRendererComponent(
        tree, value, selected, expanded, leaf, row, hasFocus);
    if(o==null || !(o instanceof ProgressObject)) {
      return c;
    }
    ProgressObject n = (ProgressObject)o;
    int i = n.getValue();
    b.setValue(i);

    FontMetrics metrics = c.getFontMetrics(c.getFont());
    int ww = getX() + getIcon().getIconWidth() + getIconTextGap()
      + metrics.stringWidth(n.title);
    nodeWidth = ww;

    p.removeAll();
    p.add(c);
    p.add(i&lt;100 ? b : Box.createVerticalStrut(barHeight), BorderLayout.SOUTH);
    return p;
  }
}
</code></pre>

### 解説
上記のサンプルでは、タスクが実行中の場合、ノードの幅(アイコンと文字列)だけの長さを持つ`JProgressBar`を配置する`TreeCellRenderer`を作成して、これを`JTree#setCellRenderer(...)`で設定しています。

- スタートボタンを押すと、`JButton`を選択不可にし、`SwingWorker`を起動して葉以外のノードをすべて捜査
- 取得した各ノードで、ダミーの`SwingWorker`を`ExecutorService#execute(...)`で起動し、進捗を`JProgressBar`を配置した`TreeCellRenderer`で表示
    - ダミータスクが終了するとそのノードを展開
- すべてのノードのタスクが終了したことを`ExecutorService#awaitTermination(...)`で検知したら、`JButton`を選択可に戻す

<!-- dummy comment line for breaking list -->

### コメント