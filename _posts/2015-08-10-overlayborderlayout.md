---
layout: post
category: swing
folder: OverlayBorderLayout
title: Component上に重ねて配置したダイアログの表示状態をアニメーション付きで切り替える
tags: [LayoutManager, JPanel, Timer, Animation, InputMap, ActionMap]
author: aterai
pubdate: 2015-08-10T13:10:18+09:00
description: Component上に重ねて配置した検索用ダイアログの位置をアニメーション付きで変更するレイアウトマネージャーを作成し、その表示非表示をキー入力で切り替えます。
image: https://lh3.googleusercontent.com/-gEMKmLyIHno/VcgZ2tpTyMI/AAAAAAAAN-0/HLb8wuLN_LE/s800-Ic42/OverlayBorderLayout.png
comments: true
---
## 概要
`Component`上に重ねて配置した検索用ダイアログの位置をアニメーション付きで変更するレイアウトマネージャーを作成し、その表示非表示をキー入力で切り替えます。

{% download https://lh3.googleusercontent.com/-gEMKmLyIHno/VcgZ2tpTyMI/AAAAAAAAN-0/HLb8wuLN_LE/s800-Ic42/OverlayBorderLayout.png %}

## サンプルコード
<pre class="prettyprint"><code>JPanel p = new JPanel() {
  @Override public boolean isOptimizedDrawingEnabled() {
    return false;
  }
};
p.setLayout(new BorderLayout(0, 0) {
  @Override public void layoutContainer(Container parent) {
    synchronized (parent.getTreeLock()) {
      Insets insets = parent.getInsets();
      int width = parent.getWidth();
      int height = parent.getHeight();
      int top = insets.top;
      int bottom = height - insets.bottom;
      int left = insets.left;
      int right = width - insets.right;
      Component nc = getLayoutComponent(parent, BorderLayout.NORTH);
      if (Objects.nonNull(nc)) {
        Dimension d = nc.getPreferredSize();
        int vsw = UIManager.getInt("ScrollBar.width");
        nc.setBounds(right - d.width - vsw, yy - d.height, d.width, d.height);
      }
      Component cc = getLayoutComponent(parent, BorderLayout.CENTER);
      if (Objects.nonNull(cc)) {
        cc.setBounds(left, top, right - left, bottom - top);
      }
    }
  }
});
p.add(searchBox, BorderLayout.NORTH);
p.add(new JScrollPane(tree));
</code></pre>

## 解説
- `BorderLayout#layoutContainer(...)`メソッドをオーバーライドし、`BorderLayout.NORTH`で追加した検索ダイアログを`OverlayLayout`のように`BorderLayout.CENTER`で追加した`JTree`に重ねて配置
    - `BorderLayout.CENTER`と`BorderLayout.NORTH`のみ対応
    - 検索ダイアログの幅は、`BorderLayout`の`BorderLayout.NORTH`配置のように親コンポーネントの幅まで拡張せず、`FlowLayout`などと同様に`PreferredSize`固定
    - `UIManager.getInt("ScrollBar.width")`で取得したスクロールバーの幅だけ右側に余白を作成して検索ダイアログを配置
- `Timer`を使った検索ダイアログ位置変更によるスライドインアニメーション
    - 参考: [JToolBarの半透明化とアニメーション](https://ateraimemo.com/Swing/TranslucentToolBar.html)、[JTextAreaをキャプションとして画像上にスライドイン](https://ateraimemo.com/Swing/EaseInOut.html)
- `JTree`を配置した`JScrollPane`と検索用ダイアログ(`JPanel`)といった子コンポーネント同士がオーバーラップするので、親の`JPanel`の`isOptimizedDrawingEnabled()`が`false`を返すようにオーバーライドする必要がある
    - 参考: [JScrollBarを半透明にする](https://ateraimemo.com/Swing/TranslucentScrollBar.html)
- 検索用ダイアログが開くと内部の`JTextField`にフォーカスが移動するように`AncestorListener`を設定
    - 参考: [JOptionPaneのデフォルトフォーカス](https://ateraimemo.com/Swing/OptionPaneDefaultFocus.html)
- `JTree`のノード検索
    - 参考: [JTreeのノードを検索する](https://ateraimemo.com/Swing/SearchBox.html)
    - <kbd>Ctrl+F</kbd>: 検索用ダイアログの表示非表示切り替え
    - <kbd>Esc</kbd>: 検索用ダイアログを閉じる
    - <kbd>Enter</kbd>: `JTree`のノードを検索

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JScrollBarを半透明にする](https://ateraimemo.com/Swing/TranslucentScrollBar.html)
- [JOptionPaneのデフォルトフォーカス](https://ateraimemo.com/Swing/OptionPaneDefaultFocus.html)
- [JTreeのノードを検索する](https://ateraimemo.com/Swing/SearchBox.html)

<!-- dummy comment line for breaking list -->

## コメント
