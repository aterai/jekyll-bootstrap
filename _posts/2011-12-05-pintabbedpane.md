---
layout: post
category: swing
folder: PinTabbedPane
title: JTabbedPaneのタブを固定する
tags: [JTabbedPane, JPopupMenu, JLabel]
author: aterai
pubdate: 2011-12-05T14:18:41+09:00
description: JTabbedPaneにJPopupMenuを追加して、指定したタブのタイトルと位置を変更し、タブの固定を行います。
image: https://lh4.googleusercontent.com/-QqKPFV0ZzIc/TttWYFUshII/AAAAAAAABFk/6HcCBI_bg-0/s800/PinTabbedPane.png
comments: true
---
## 概要
`JTabbedPane`に`JPopupMenu`を追加して、指定したタブのタイトルと位置を変更し、タブの固定を行います。

{% download https://lh4.googleusercontent.com/-QqKPFV0ZzIc/TttWYFUshII/AAAAAAAABFk/6HcCBI_bg-0/s800/PinTabbedPane.png %}

## サンプルコード
<pre class="prettyprint"><code>pinTabMenuItem = new JCheckBoxMenuItem(new AbstractAction("pin tab") {
  @Override public void actionPerformed(ActionEvent e) {
    JTabbedPane t = (JTabbedPane) getInvoker();
    JCheckBoxMenuItem check = (JCheckBoxMenuItem) e.getSource();
    int idx       = t.getSelectedIndex();
    Component cmp = t.getComponentAt(idx);
    Component tab = t.getTabComponentAt(idx);
    Icon icon     = t.getIconAt(idx);
    String tip    = t.getToolTipTextAt(idx);
    boolean flg   = t.isEnabledAt(idx);

    int i;
    if (check.isSelected()) {
      for (i = 0; i &lt; idx; i++) {
        String s = t.getTitleAt(i);
        if (s == null || s.isEmpty()) {
          continue;
        }
        break;
      }
    } else {
      for (i = t.getTabCount() - 1; i &gt; idx; i--) {
        String s = t.getTitleAt(i);
        if (s != null &amp;&amp; !s.isEmpty()) {
          continue;
        }
        break;
      }
    }
    t.remove(idx);
    t.insertTab(check.isSelected() ? "" : tip, icon, cmp, tip, i);
    t.setTabComponentAt(i, tab);
    t.setEnabledAt(i, flg);
    if (flg) {
      t.setSelectedIndex(i);
    }
  }
});
</code></pre>

## 解説
- タブを固定
    - タブタイトルを空にする
    - タブの位置を左側に移動
    - 固定したタブは削除不可
- タブの固定を解除
    - タブタイトルを`TooltipText`から復元する
    - タブの位置を固定されていないタブの右側に移動
- 注:
    - `TabPlacement`: `LEFT`, `RIGHT`は考慮していない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [XP Style Icons - Download](https://xp-style-icons.en.softonic.com/)

<!-- dummy comment line for breaking list -->

## コメント
