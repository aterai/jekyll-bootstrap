---
layout: post
title: JSplitPaneでディバイダの移動を連続的に再描画
category: swing
folder: ContinuousLayout
tags: [JSplitPane, PropertyChangeListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-07-12

## JSplitPaneでディバイダの移動を連続的に再描画
二つの`JSplitPane`のディバイダで、移動の同期と連続的な再描画を行います。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTKL-SYs6I/AAAAAAAAAVk/pXv9HlMSLf0/s800/ContinuousLayout.png)

### サンプルコード
<pre class="prettyprint"><code>final JSplitPane leftPane   = new JSplitPane(JSplitPane.VERTICAL_SPLIT);
final JSplitPane rightPane  = new JSplitPane(JSplitPane.VERTICAL_SPLIT);
final JSplitPane centerPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);

leftPane.setTopComponent(new JScrollPane(new JTextArea("aaaaaaa")));
leftPane.setBottomComponent(new JScrollPane(new JTextArea("bbbb")));
rightPane.setTopComponent(new JScrollPane(new JTree()));
rightPane.setBottomComponent(new JScrollPane(new JTree()));
centerPane.setLeftComponent(leftPane);
centerPane.setRightComponent(rightPane);

leftPane.setResizeWeight(.5);
rightPane.setResizeWeight(.5);
centerPane.setResizeWeight(.5);

PropertyChangeListener pcl = new PropertyChangeListener() {
  @Override public void propertyChange(PropertyChangeEvent e) {
    if(JSplitPane.DIVIDER_LOCATION_PROPERTY.equals(e.getPropertyName())) {
      JSplitPane source = (JSplitPane)e.getSource();
      int location = ((Integer)e.getNewValue()).intValue();
      JSplitPane target = (source==leftPane)?rightPane:leftPane;
      if(location != target.getDividerLocation())
          target.setDividerLocation(location);
    }
  }
};
leftPane.addPropertyChangeListener(pcl);
rightPane.addPropertyChangeListener(pcl);
</code></pre>

### 解説
上記のサンプルでは、`JSplitPane`を`3`つ使用して、`4`つのコンポーネントを分割表示しています。

- - - -
左右に配置されたディバイダが、同期して移動するように以下のように設定しています。

- 片方のディバイダが上下移動したら、残りも移動するように`PropertyChangeListener`を追加
- `JSplitPane#setContinuousLayout(true)`として、移動を連続的に再描画

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Regading SplitPanes | Oracle Forums](https://forums.oracle.com/message/5816154)

<!-- dummy comment line for breaking list -->

### コメント