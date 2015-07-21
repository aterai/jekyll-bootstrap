---
layout: post
category: swing
folder: SwapInternalFramesWithTabs
title: JDesktopPane内のJInternalFrameをJTabbedPaneのタブと入れ替える
tags: [JDesktopPane, JInternalFrame, JTabbedPane, CardLayout]
author: aterai
pubdate: 2015-04-13T00:00:05+09:00
description: JDesktopPaneとJTabbedPaneをCardLayoutで切り替えるとき、その内部のJInternalFrameとタブもすべて入れ替えます。
comments: true
---
## 概要
`JDesktopPane`と`JTabbedPane`を`CardLayout`で切り替えるとき、その内部の`JInternalFrame`とタブもすべて入れ替えます。

{% download https://lh4.googleusercontent.com/-mNR8hjjt8Ao/VSp_fRS8WZI/AAAAAAAAN2Y/rTsBE6-6Ekg/s800/SwapInternalFramesWithTabs.png %}

## サンプルコード
<pre class="prettyprint"><code>Action swapAction = new AbstractAction("JDesktopPane &lt;-&gt; JTabbedPane") {
  @Override public void actionPerformed(ActionEvent e) {
    if (((AbstractButton) e.getSource()).isSelected()) {
      Arrays.stream(desktopPane.getAllFrames())
        .sorted(Comparator.comparing(JInternalFrame::getTitle))
        .forEach(f -&gt; tabbedPane.addTab(
            f.getTitle(), f.getFrameIcon(), f.getContentPane()));

      JInternalFrame sf = desktopPane.getSelectedFrame();
      if (Objects.nonNull(sf)) {
        tabbedPane.setSelectedIndex(tabbedPane.indexOfTab(sf.getTitle()));
      }
      cardLayout.show(panel, tabbedPane.getClass().getName());
    } else {
      Arrays.stream(desktopPane.getAllFrames())
      .forEach(f -&gt; f.setContentPane(
          (Container) tabbedPane.getComponentAt(
              tabbedPane.indexOfTab(f.getTitle()))));
      cardLayout.show(panel, desktopPane.getClass().getName());
    }
  }
};
</code></pre>

## 解説
- `JInternalFrame`をタブに変換する
    - `JDesktopPane#getAllFrames()`で取得した順番は、`JInternalFrame`がアイコン化されているなどの状態で変化するので、タイトルでソートしてから`JTabbedPane`に追加
    - `JInternalFrame`自体はそのままで、`ContentPane`のみタブコンポーネントに変換する
    - 選択状態の`JInternalFrame`を`JDesktopPane#getSelectedFrame()`で検索し、変換先のタブも選択状態になるよう`JTabbedPane#setSelectedIndex(...)`で設定する
- タブを`JInternalFrame`に変換する
    - `JDesktopPane`には、位置やサイズ、アイコン化状態などを保存した状態で`JInternalFrame`が残っている
        - `JTabbedPane`側ではタブの削除を許可していない
    - `JInternalFrame`のタイトルと同じタブのインデックスを`JTabbedPane#indexOfTab(String)`で検索し、そのコンポーネントを`ContentPane`として`JInternalFrame`に戻す

<!-- dummy comment line for breaking list -->

## コメント